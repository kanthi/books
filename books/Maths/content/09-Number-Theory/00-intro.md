# Number Theory for Computer Science

Number theory studies the integers—and in CS it is the mathematics of modular arithmetic, primes, and discrete structure behind cryptography, hashing, coding, and competitive programming. This introduction builds the conceptual map and proves you can already use the main tools.

## Why number theory is core CS math

| Domain | Number-theoretic ingredient |
|--------|------------------------------|
| Public-key crypto | Modular exponentiation, primes, groups $(\mathbb{Z}/n\mathbb{Z})^\times$ |
| Hashing / PRGs | Modular reduction, linear congruential ideas |
| Checksums | Parity and modular checksums |
| Competitive programming | GCD, inverses, CRT, fast powmod |
| Coding theory | Finite fields (built from modular poly arithmetic) |
| Graphics / games | Integer lattice tricks, wraparound arithmetic |

## Concept map

```text
flow:
  B -> C
  B -> D
  C -> E
  E -> F
  E -> G
  G -> H
  A -> I
  I -> H
```

## Divisibility and gcd (preview)

$d\mid a$ means $\exists k\in\mathbb{Z}$, $a=dk$.  
$\gcd(a,b)$ is the largest positive common divisor.

**Euclidean algorithm:** $\gcd(a,b)=\gcd(b,a\bmod b)$ with $\gcd(a,0)=|a|$. Runtime $O(\log\min(|a|,|b|))$ steps.

### Worked example 1

$\gcd(1001,143)$: $1001=7\cdot 143+0$? $143\cdot 7=1001$, so $\gcd=143$.

### Worked example 2 — Bézout

$\gcd(a,b)=ax+by$ for some integers $x,y$ (extended Euclid). Essential for modular inverses.

## Modular arithmetic (preview)

$a\equiv b\pmod n$ means $n\mid(a-b)$. Residues $\{0,1,\ldots,n-1\}$ form a ring.

**Inverse:** $a^{-1}\bmod n$ exists iff $\gcd(a,n)=1$. Then $ax\equiv 1\pmod n$ solvable.

### Worked example 3

Inverse of $3$ mod $10$: $3\cdot 7=21\equiv 1$, so $7$.  
Inverse of $2$ mod $10$: none ($\gcd=2\neq 1$).

### Worked example 4 — fast pow

Compute $a^e\bmod n$ by binary exponentiation in $O(\log e)$ multiplications—backbone of RSA and Diffie–Hellman operations.

## Fermat and Euler (preview)

**Fermat:** if $p$ prime and $p\nmid a$, then $a^{p-1}\equiv 1\pmod p$.  
**Euler:** if $\gcd(a,n)=1$, then $a^{\varphi(n)}\equiv 1\pmod n$.

### Worked example 5

Inverse of $a$ mod prime $p$ is $a^{p-2}\bmod p$ (Fermat)—when $p$ huge, use powmod carefully.

## Chinese Remainder Theorem (preview)

If $n_1,\ldots,n_k$ pairwise coprime, system $x\equiv a_i\pmod{n_i}$ has unique solution mod $N=\prod n_i$.

### Worked example 6

$x\equiv 2\pmod 5$, $x\equiv 3\pmod 7$: try $x=17$ ($17=3\cdot 5+2$, $17=2\cdot 7+3$). Mod $35$, unique class.

## RSA sketch (motivation)

Pick primes $p,q$, $n=pq$, $\varphi=(p-1)(q-1)$, choose $e$ coprime to $\varphi$, $d\equiv e^{-1}\pmod{\varphi}$.  
Encrypt $c\equiv m^e\pmod n$; decrypt $m\equiv c^d\pmod n$ (for $m$ in range, with padding in practice).

Security intuition: factoring $n$ (or equivalent hardness) should be hard—**not** a theorem that $\mathbf{P}\neq\mathbf{NP}$, but a concrete computational assumption.

### Worked example 7 — tiny RSA

$p=3,q=11,n=33,\varphi=20,e=3,d=7$ because $21\equiv 1\pmod{20}$. Message $m=4$: $c=4^3=64\equiv 31\pmod{33}$; $31^7\bmod 33$ recovers $4$ (compute carefully).

## Primes and primality

Infinitely many primes (Euclid). Density $\sim 1/\ln n$ (prime number theorem). Primality is in $\mathbf{P}$ (AKS); practice uses Miller–Rabin probabilistic tests.

### Worked example 8

Trial division to $\sqrt{n}$ is $O(\sqrt n)$—fine for 64-bit sometimes, hopeless for 2048-bit RSA moduli.

## Hashing connection

Map keys into $\{0,\ldots,m-1\}$ by $h(k)=k\bmod m$ or multiplicative methods. Universality needs number-theoretic or combinatorial designs—mod alone is not always enough for adversarial keys.

### Worked example 9

Bad $m$ and structured keys cause collisions; cryptographic hashes use different designs but still modular arithmetic internally in many constructions.

## Proof styles to practice

1. **Constructive:** exhibit Bezout coefficients  
2. **Contradiction:** Euclid’s infinitude of primes  
3. **Induction:** modular power laws  
4. **Equivalence:** $a\equiv b\pmod m\Leftrightarrow m\mid(a-b)$  

### Worked example 10

Prove: if $d\mid a$ and $d\mid b$ then $d\mid(ax+by)$ for all integers $x,y$—one line from definitions.

## Pitfalls

1. Division mod $n$ without invertibility  
2. Reducing exponent incorrectly (use $\varphi(n)$ only when coprime)  
3. Overflow in intermediate products before mod  
4. Using Fermat test alone as primality proof (Carmichael numbers)  
5. Toy RSA without padding as “secure encryption”  

## Roadmap of this part

1. Divisibility and GCD  
2. Modular arithmetic  
3. Primes and crypto  

## Checkpoint

- Run Euclid and extended Euclid mentally on small inputs  
- Solve $ax\equiv 1\pmod n$ when possible  
- State Fermat and when it applies  
- Solve a 2-modulus CRT system  
- Explain RSA’s $(n,e,d)$ roles without claiming security proofs  

## Exercises

1. Prove: if $d\mid a$ and $d\mid b$ then $d\mid(ax+by)$ for all $x,y\in\mathbb{Z}$.
2. Compute $\gcd(1001,143)$ and Bézout coefficients.
3. Solve $x\equiv 2\pmod 5$, $x\equiv 3\pmod 7$.
4. When is modular division by $b$ valid mod $m$?
5. Compute $3^{100}\bmod 7$ using Fermat.
6. Find inverse of $5$ mod $17$ two ways (extended Euclid; Fermat).
7. Show there are infinitely many primes (Euclid outline).
8. Why is $a^{n-1}\equiv 1\pmod n$ for all $a$ coprime to $n$ not true for all composite $n$ with a cheap test alone? (Carmichael mention)
9. Implement (pseudocode) binary modular exponentiation; count multiplications for $e$ with $k$ bits.
10. CRT for three moduli $3,4,5$ with remainders $2,3,1$.
11. Tiny RSA: encrypt and decrypt one message with $n=55$, choose valid $e,d$.
12. Hashing: give an example where $k\bmod m$ collides heavily for arithmetic progressions of keys.
13. Prove $\gcd(a,b)=\gcd(a,b-a)$ and connect to Euclid.
14. Explain why RSA decryption works using Euler’s theorem (coprime $m$ case).
15. Checkpoint essay: list three production systems using modular arithmetic and what fails if inverses are missing.

## Summary

Number theory supplies the integer toolkit for secure and efficient computation: gcd, modular inverses, exponentiation, CRT, and primes. The following chapters develop each pillar with algorithms and cryptographic constructions.
