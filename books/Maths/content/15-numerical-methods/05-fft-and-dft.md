# Discrete Fourier Transforms and the FFT

The discrete Fourier transform (DFT) turns a length-$n$ sequence into $n$ complex frequency bins. A naive implementation costs $O(n^2)$ arithmetic; the **fast Fourier transform (FFT)** family evaluates the same mathematical transform in $O(n\log n)$ time. That gap is why spectral methods, convolution via FFT, and large-scale signal processing are practical on ordinary hardware.

This chapter defines the DFT, explains the Cooley–Tukey radix-2 idea, states the convolution theorem, and catalogs the practical pitfalls that dominate real use: windowing, spectral leakage, real-vs-complex transforms, and normalization conventions.

## 1. The DFT

Let $a_0,\ldots,a_{n-1}\in\mathbb{C}$. The **forward DFT** (NumPy / Oppenheim–Schafer “engineering” sign convention) is

$$
A_k=\sum_{m=0}^{n-1}a_m\,e^{-2\pi i\,mk/n},\qquad k=0,\ldots,n-1.
$$

The **inverse DFT** recovers the samples:

$$
a_m=\frac{1}{n}\sum_{k=0}^{n-1}A_k\,e^{2\pi i\,mk/n},\qquad m=0,\ldots,n-1.
$$

**Mental model:** each $A_k$ is the inner product of the signal against the complex sinusoid of discrete frequency $k/n$ cycles per sample. Index $k=0$ is DC (sum of the signal). For real input, $A_{n-k}=\overline{A_k}$ (Hermitian symmetry).

### Worked example 1 — DC and Nyquist

Take $n=4$, $a=(1,1,1,1)$. Then $A=(4,0,0,0)$: all energy at DC. For $a=(1,-1,1,-1)$, energy sits at the Nyquist bin $k=2$ when $n$ is even.

### Worked example 2 — pure tone

Sampling $a_m=\cos(2\pi f_0 m\Delta t)$ with $f_0=k_0/(n\Delta t)$ for integer $k_0$ puts energy in bins $k_0$ and $n-k_0$ only. If $f_0$ is **not** an integer number of cycles over the window, energy **leaks** into neighboring bins (Section 6).

## 2. Matrix view and complexity

Write $\omega=e^{-2\pi i/n}$. Then $A=Fa$ with the Fourier matrix

$$
F_{km}=\omega^{km}.
$$

Dense matrix–vector multiply is $\Theta(n^2)$ complex multiplies/adds. The FFT reuses shared twiddle factors and butterfly structure so the **same** $F a$ costs $\Theta(n\log n)$.

| Method | Leading cost | Notes |
|--------|--------------|-------|
| Direct DFT sum | $O(n^2)$ | Fine for tiny $n$; pedagogical |
| Radix-2 Cooley–Tukey | $O(n\log n)$ | Best when $n=2^p$ |
| Mixed-radix / Bluestein | $O(n\log n)$ | Arbitrary $n$ (library default) |
| Real FFT (`rfft`) | $\sim$ half complex work | Exploits Hermitian symmetry |

### Worked example 3 — when the constant matters

For $n=2^{20}\approx 10^6$, $n^2\sim 10^{12}$ ops is hours of CPU; $n\log_2 n\sim 2\cdot 10^7$ is milliseconds. Always prefer a library FFT for $n\gtrsim 64$.

## 3. Cooley–Tukey radix-2 intuition

Assume $n=2p$. Split even and odd indices:

$$
\begin{aligned}
A_k &= \sum_{j=0}^{p-1}a_{2j}\,\omega^{2jk}+\omega^k\sum_{j=0}^{p-1}a_{2j+1}\,\omega^{2jk}\\
&= E_k + \omega^k O_k,
\end{aligned}
$$

where $E$ and $O$ are length-$p$ DFTs of the even/odd subsequences, and $\omega^k$ is a **twiddle**. Because of periodicity, $E_{k+p}=E_k$ and $O_{k+p}=O_k$, so one pair of half-size DFTs plus $n$ twiddle/combine steps yields the full transform.

**Recurrence:** $T(n)=2T(n/2)+\Theta(n)$ $\Rightarrow$ $T(n)=\Theta(n\log n)$.

```text
butterfly (radix-2):
  even DFT ──► E_k ──┐
                     ├─► A_k     = E_k + W^k O_k
  odd  DFT ──► O_k ──┘   A_{k+p} = E_k - W^k O_k
                 W^k = exp(-2π i k / n)
```

### Worked example 4 — $n=8$

Three stages of butterflies: bit-reversal permutation of inputs (or outputs, depending on formulation), then combine length-2, length-4, length-8 transforms. Counting: $3\cdot 8=24$ butterflies, each $O(1)$ arithmetic $\Rightarrow$ matches $n\log_2 n$.

**Libraries:** production code (NumPy’s PocketFFT, FFTW, MKL) uses mixed radices (2,3,4,5,…), not only pure radix-2. The Cooley–Tukey story still explains *why* $O(n\log n)$ is achievable.

## 4. Convolution theorem

For circular (periodic) convolution of length-$n$ sequences $a$ and $b$,

$$
(a*b)_m=\sum_{j=0}^{n-1}a_j\,b_{(m-j)\bmod n},
$$

the DFT turns convolution into pointwise products:

$$
\widehat{a*b}=A\odot B
\qquad\text{(elementwise)}.
$$

**Algorithm:**

1. Zero-pad $a$ and $b$ to length $N\ge n_a+n_b-1$ (linear convolution) or use $N=n$ for circular.  
2. $A=\mathrm{FFT}(a)$, $B=\mathrm{FFT}(b)$.  
3. $C_k=A_k B_k$.  
4. $c=\mathrm{IFFT}(C)$.

Cost $O(N\log N)$ vs $O(n_a n_b)$ direct. Break-even is often modest ($N$ hundreds), so FFT convolution dominates large filters and polynomial multiplication.

### Worked example 5 — polynomial multiply

Coefficients of $p(x)q(x)$ are the linear convolution of coefficient vectors—exactly the setting for FFT multiplication of large integers / polynomials (with care for rounding if using floating FFT).

## 5. Real vs complex; normalization

| API idea | Use when | Output size |
|----------|----------|-------------|
| Complex `fft` / `ifft` | General complex signals | $n$ complex |
| Real `rfft` / `irfft` | Real time series | $n/2+1$ complex (positive freqs) |
| Hermitian `hfft` | Real spectrum / Hermitian time | complementary packing |

**Normalization conventions** (NumPy `norm=`):

| Mode | Forward | Inverse |
|------|---------|---------|
| `"backward"` (default) | unscaled | $/n$ |
| `"ortho"` | $1/\sqrt{n}$ | $1/\sqrt{n}$ (unitary) |
| `"forward"` | $/n$ | unscaled |

Parseval / energy identities need a consistent convention. Prefer `"ortho"` when comparing “energy in time = energy in frequency.”

### Worked example 6 — Hermitian check

```python
# file: hermitian_check.py
import numpy as np

rng = np.random.default_rng(0)
x = rng.standard_normal(128)
X = np.fft.fft(x)
# X[k] should ≈ conj(X[-k]) for real x
err = np.max(np.abs(X[1:] - np.conj(X[:0:-1])))
print(err)  # ~1e-15
```

## 6. Windowing, leakage, and sampling traps

The DFT implicitly assumes the length-$n$ buffer is **one period** of a periodic signal. Abrupt truncation $\Rightarrow$ discontinuities at the wrap $\Rightarrow$ **spectral leakage** (sinc-like sidelobes).

**Mitigations:**

- Choose $n$ so tones complete an integer number of cycles (rare in the wild).  
- Apply a **window** (Hann, Hamming, Blackman, Kaiser) before the FFT; trade main-lobe width vs sidelobe height.  
- Zero-pad *after* windowing for denser frequency grid (interpolation of the DTFT of the windowed segment—not new information).

**Sampling:** to resolve frequency $f$, need sample rate $f_s>2f$ (Nyquist). Aliasing folds energy above $f_s/2$ into lower bins—anti-alias filter before downsample.

### Worked example 7 — leakage demo (conceptual)

A pure cosine that is **not** periodic in the buffer shows a broad hump instead of two spikes. Hann windowing narrows the mess at the cost of a slightly wider main lobe.

## 7. Frequencies and units

For sample spacing $\Delta t$ (seconds),

$$
f_k=\frac{k}{n\Delta t},\qquad k=0,\ldots,n-1
$$

(with negative frequencies represented in the upper half of the array). Helpers:

- `fftfreq(n, d=Δt)` — bin centers for `fft`  
- `rfftfreq` — for `rfft`  
- `fftshift` — rotate so DC is centered for plots  

### Worked example 8 — reading a spectrum

$n=1000$, $\Delta t=0.001$ s $\Rightarrow$ $f_s=1000$ Hz, frequency resolution $\Delta f=1$ Hz. A peak at bin $k=50$ is $50$ Hz.

## 8. Runnable mini-FFT (radix-2, educational)

```python
# file: tiny_radix2_fft.py
# Educational radix-2 FFT (not for production). Prefer numpy.fft.
import cmath
import math


def fft_radix2(a):
    """In-place-ish Cooley–Tukey; returns new list. n must be power of 2."""
    n = len(a)
    if n == 1:
        return [a[0]]
    if n & (n - 1):
        raise ValueError("length must be a power of 2")
    even = fft_radix2(a[0::2])
    odd = fft_radix2(a[1::2])
    out = [0j] * n
    for k in range(n // 2):
        w = cmath.exp(-2j * math.pi * k / n)
        t = w * odd[k]
        out[k] = even[k] + t
        out[k + n // 2] = even[k] - t
    return out


def dft_direct(a):
    n = len(a)
    return [
        sum(a[m] * cmath.exp(-2j * math.pi * m * k / n) for m in range(n))
        for k in range(n)
    ]


if __name__ == "__main__":
    x = [1, 2, 3, 4, 3, 2, 1, 0]
    F = fft_radix2(x)
    D = dft_direct(x)
    err = max(abs(F[k] - D[k]) for k in range(len(x)))
    print("max |FFT - DFT| =", err)
    # expected: ~1e-15
```

Complexity of this recursive form is still $O(n\log n)$, but constant factors and cache behavior are far worse than library FFTs.

## 9. Stability and floating-point notes

- Unitary (`ortho`) FFTs have excellent backward stability in practice; roundoff grows like $O(\varepsilon\sqrt{\log n})$ under mild models (see Numerical Recipes / Higham-style analyses).  
- Large forward transforms of huge signals: prefer double for analysis unless memory forces `float32` (and know libraries may promote).  
- FFT convolution of integers via floats needs enough mantissa bits or modular/NTT alternatives for exact arithmetic.

### Worked example 9 — residual check

Round-trip `ifft(fft(x))` should match $x$ to $\sim 10^{-15}$ relative for double and moderate $n$. Larger residuals often mean wrong `norm`, wrong `irfft` length, or non-Hermitian edits to a real spectrum.

## 10. Algorithms beyond radix-2 (map)

| Family | Idea |
|--------|------|
| Mixed-radix CT | Factor $n=n_1 n_2$; recurse |
| Stockham / self-sorting | Avoid explicit bit-reversal |
| Bluestein / chirp-z | Arbitrary $n$ via convolution |
| Prime-factor (Good–Thomas) | Coprime factors, no twiddles between |
| Real-packed / split-radix | Fewer real ops for real data |

You rarely implement these; you **choose** library plans (FFTW wisdom, cuFFT, PocketFFT) that pick a factorization for your $n$.

## 11. CS applications (numerical methods view)

- Fast Poisson / Helmholtz on regular grids (spectral / FFT Poisson solvers)  
- Convolutional filtering and matched filters  
- Polynomial and large-integer multiplication  
- Time–frequency features (STFT = windowed consecutive FFTs)  
- Circulant preconditioners and Toeplitz embedding  

Related numerical themes: conditioning of Vandermonde-like Fourier modes is excellent for pure harmonics; leakage and window choice dominate *interpretation* error more often than roundoff.

## 12. Pitfalls

1. Treating DFT bins as continuous frequencies without stating $\Delta f=1/(n\Delta t)$.  
2. Circular convolution when you meant linear (forgot padding).  
3. Editing only half a spectrum then `ifft` without restoring Hermitian symmetry $\Rightarrow$ complex time signal.  
4. Comparing amplitudes across different `norm` modes or windows without calibration.  
5. Expecting $O(n\log n)$ magic from a hand-rolled $O(n^2)$ nested loop labeled “FFT.”  
6. Interpreting zero-padding as higher frequency *resolution* of new information (it interpolates the spectrum of the *same* windowed segment).

## 13. Checkpoint

- Write the forward/inverse DFT pair and explain $A_0$.  
- Derive the even/odd split that yields $T(n)=2T(n/2)+O(n)$.  
- State the convolution theorem and when to zero-pad.  
- Explain leakage and one windowing remedy.  
- Choose `fft` vs `rfft` and a `norm` mode for an energy-preserving pipeline.

## Exercises

### Easy

1. Compute the DFT of $(1,0,-1,0)$ by hand ($n=4$).  
2. Why is $A_0$ real when $a$ is real?  
3. Cost ratio $n^2/(n\log_2 n)$ for $n=1024$.  
4. What does `fftshift` change—values or order?  
5. Give one reason to prefer `rfft` on real audio.

### Medium

6. Prove Hermitian symmetry $A_{n-k}=\overline{A_k}$ for real $a$.  
7. Show that circular convolution $\leftrightarrow$ pointwise DFT products.  
8. Explain why a Hann window reduces leakage (qualitative Fourier picture).  
9. Design padding length for linear convolution of lengths $n$ and $m$.  
10. Compare `"backward"` vs `"ortho"` for Parseval.

### Challenge

11. Implement iterative (non-recursive) radix-2 FFT with explicit bit reversal.  
12. Derive the Bluestein reduction of arbitrary-$n$ DFT to convolution at high level.  
13. Analyze round-trip error vs $n$ for `float32` vs `float64`.  
14. Connect Toeplitz matrix–vector products to FFT embedding.  
15. STFT: trade hop size, window length, and time–frequency resolution.

## Summary

The DFT is an exact $n\times n$ change of basis; the FFT is a fast algorithm for that basis change. Master the definition, the $O(n\log n)$ butterfly intuition, convolution-via-FFT, and the measurement pitfalls (windows, leakage, normalization, real packing). Use library FFTs in production; use the tiny radix-2 listing only to cement the mental model.

## Sources (for further reading)

- Cooley & Tukey (1965), “An algorithm for the machine calculation of complex Fourier series.”  
- Oppenheim & Schafer, *Discrete-Time Signal Processing* — DFT/FFT and windowing chapters.  
- Press et al., *Numerical Recipes*, FFT chapters — accessible algorithmic notes.  
- NumPy `numpy.fft` documentation — conventions, `rfft`, normalization modes.
