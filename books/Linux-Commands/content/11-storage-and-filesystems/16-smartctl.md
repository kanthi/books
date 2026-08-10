# smartctl

## Overview

`smartctl` (from **smartmontools**) queries disk **S.M.A.R.T.** health data: overall assessment, attributes, error logs, and self-tests. Use it for predictive failure monitoring on HDDs/SSDs/NVMe (device-dependent).

```bash
sudo apt install smartmontools
```

## Syntax

```bash
sudo smartctl [options] device
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` / `-x` | All / extended SMART info |
| `-H` | Overall health PASS/FAIL |
| `-i` | Identity |
| `-A` | Vendor attributes table |
| `-l error` | Error log |
| `-l selftest` | Self-test log |
| `-t short\|long\|conveyance` | Start self-test |
| `-s on` | Enable SMART (if disabled) |
| `-d type` | Device type (raid, nvme, …) |

## Safety

- Long self-tests stress disks — schedule during maintenance.  
- On hardware RAID, you often need `-d megaraid,N` or controller tools; smartctl on `/dev/sdX` may talk to the virtual disk only.  
- SMART “PASSED” is not a guarantee — watch reallocated sectors and media errors over time.

## Examples with Explanations

### Health summary

```bash
sudo smartctl -H /dev/sda
sudo smartctl -i /dev/sda
```

### Full report

```bash
sudo smartctl -a /dev/sda | less
sudo smartctl -x /dev/nvme0 | less
```

### Short self-test

```bash
sudo smartctl -t short /dev/sda
# wait, then:
sudo smartctl -l selftest /dev/sda
```

### Watch failure predictors

```bash
sudo smartctl -A /dev/sda | egrep -i 'reall|pend|uncorrect|media|temperature'
```

### Scan devices

```bash
sudo smartctl --scan
```

## Related Commands

- `lsblk` / `nvme` — device inventory  
- `dmesg` — I/O errors  
- `hdparm` — identify / timings (older ATA focus)  
- `smartd` — background monitoring daemon  

## Additional Resources

- `man smartctl`  
- smartmontools FAQ
