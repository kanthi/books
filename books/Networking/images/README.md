# Networking diagrams

**Style is monorepo-wide.** Do not invent a Networking-only palette.

| Doc | Path |
|-----|------|
| **Standard** | `includes/diagrams/STANDARD.md` |
| **Visual reference** | `includes/diagrams/reference/diagram-reference-topology.svg` (+ `-dark`) |

The hero figure `diagram-dist-switch-multihome.svg` (+ `-dark`) is the **first production exemplar** of that standard (same look as the monorepo reference).

## Inventory (this book)

| File | Chapter use | Dark sibling |
|------|-------------|--------------|
| `diagram-dist-switch-multihome.svg` | Index hero, L2 Ethernet, syllabus | yes |
| `diagram-mac-learning.svg` | Ethernet & MAC | yes |
| `diagram-vlan-trunk.svg` | VLANs & trunks | yes |
| `diagram-campus-vlan-vrrp-ospf.svg` | Campus lab: VLANs, VRRP, OSPF | yes |
| `diagram-lab-host-budget.svg` | Lab host image budget | yes |
| `diagram-multinos-triangle.svg` | FRR, cEOS, SR Linux triangle | yes |
| `diagram-ceos-vlan-trunk.svg` | cEOS VLANs and trunk | yes |
| `diagram-ceos-stp.svg` | cEOS spanning tree | yes |
| `diagram-ceos-lag.svg` | cEOS LACP | yes |
| `diagram-ceos-vrrp.svg` | cEOS VRRP | yes |
| `diagram-ospf-areas.svg` | OSPF areas on three NOSes | yes |
| `diagram-ebgp-triangle.svg` | eBGP triangle | yes |
| `diagram-ibgp-reflector.svg` | iBGP route reflector | yes |
| `diagram-vxlan-evpn.svg` | VXLAN and EVPN leaves | yes |
| `diagram-mtu-path.svg` | Path MTU | yes |
| `diagram-stp-guards.svg` | STP edge guards | yes |
| `diagram-dhcp-snoop.svg` | DHCP snooping | yes |
| `diagram-mlag.svg` | MLAG pair | yes |
| `diagram-vrf-lite.svg` | VRF-lite | yes |
| `diagram-ospf-stub.svg` | OSPF stub area | yes |
| `diagram-redist-tag.svg` | Redistribution tag | yes |
| `diagram-bgp-med.svg` | BGP MED | yes |
| `diagram-pbr.svg` | Policy routing | yes |
| `diagram-urpf.svg` | Unicast RPF | yes |
| `diagram-span.svg` | SPAN | yes |
| `diagram-gre.svg` | GRE tunnel | yes |
| `diagram-control-plane.svg` | Control-plane ACL | yes |
| `diagram-ipv6-slaac.svg` | IPv6 SLAAC | yes |
| `diagram-ntp-syslog.svg` | NTP and syslog | yes |
| `diagram-qos-delay.svg` | Measured delay | yes |
| `diagram-ospf-auth.svg` | OSPF MD5 | yes |
| `diagram-lab-triangle.svg` | Containerlab, statics | yes |
| `diagram-leaf-spine.svg` | Clos leaf-spine | yes |
| `diagram-tailscale-vxlan-sites.svg` | Head office / branch, Tailscale + VXLAN | yes |
| `diagram-encapsulation.svg` etc. (mono) | Models / habits | n/a |

When adding illustrated figures: dual files + reference tokens + theme-swap (already in `styles/reader-mode-body.html`). Embed light path only.
