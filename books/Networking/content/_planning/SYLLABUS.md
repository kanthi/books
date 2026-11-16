# Networking syllabus

A vendor-neutral path from first principles to NetOps using diagrams, Containerlab, netlab, and multi-NOS labs. The main path uses freely available images; Cisco and Juniper are optional future additions.

1. Lab platform and first topology.
2. Foundations: frames, addressing, forwarding, transport, applications, and capture.
3. Layer 2: switching, VLANs, loops, aggregation, and failure drills.
4. IP routing and services: static routes, DHCP, DNS, NAT, redundancy, and MTU.
5. Dynamic routing: OSPF, BFD, BGP, policy, and convergence.
6. Security, operations, and automation.
7. Tunnels, overlays, and fabrics.
8. Optional advanced tracks: routing security, transport and applications, and forensics.
9. Projects and the multi-NOS lab workbook.
10. Command references and cross-platform comparisons.

Teach through concept, diagram, lab, verification, and failure drill. Follow the repository diagram standard. Preserve distinct FRR, cEOS, and SR Linux exercises and link relevant labs from core chapters. Audit troubleshooting, wireless, IPv6 operations, design, VRFs, IS-IS, and redistribution before adding chapters.

The [previous syllabus](archive/syllabus-before-reorganization.md) is retained as historical planning material. Its part numbering predates this reorganization.

## Coverage and diagram follow-up

The workbook contains labs for IS-IS, VRF-lite, redistribution, IPv6 SLAAC, packet mirroring, and failure drills; link these from future core chapters when their prerequisites are taught. Wireless now has a foundational chapter and troubleshooting exercise; expand RF design, enterprise authentication and roaming labs with reproducible platform-specific validation. Expand IPv6 operations and design/change management after reviewing the existing foundations and operations chapters for overlap.

Workbook labs include illustrated topologies or links to the topology they reuse; the EVPN and BGP policy labs link to their preceding labs. The capstone outline is a project brief rather than a single topology. Keep figures synchronized with lab node names, interfaces, and addressing and follow the shared diagram standard.

## Coverage audit: associate and enterprise professional depth

The public [200-301 v1.1](https://learningcontent.cisco.com/documents/marketing/exam-topics/200-301-CCNA-v1.1.pdf), [350-401 v1.2](https://learningcontent.cisco.com/documents/marketing/exam-topics/350-401-ENCORE-v1.2.pdf), and [300-410 v1.1](https://learningcontent.cisco.com/documents/marketing/exam-topics/300-410-ENARSI-v1.1-7-2025.pdf) outlines were consulted as breadth references. This book is vendor-neutral and does not claim exam alignment or coverage of product-specific commands; exam topics and versions can change. A chapter's existence does not prove its labs were executed or its treatment is complete.

| Domain | Existing starting points | Further work |
|---|---|---|
| Fundamentals and physical access | `02-networking-foundations/`, `03-layer-2/` | Audit optics, cabling, PoE, physical fault diagnosis and topology design for depth and labs |
| Wireless | `03-layer-2/06-wireless-lan-fundamentals.qmd` | Build and validate wireless, roaming and 802.1X scenarios with suitable equipment |
| Switching | `03-layer-2/03b-spanning-tree-election.qmd`, workbook 04–06 and 23–25 | Validate guard and failure cases across multiple implementations |
| IP routing | `04-ip-routing-services/`, workbook 09–15, 27–31, 40–42 | Add verified redundant-boundary redistribution and multi-area failure scenarios |
| IP services and IPv6 | `04-network-services/`, workbook 07, 16–17, 35–36, 43 | Validate relay, first-hop protection and dual-stack failure cases on real or emulated devices |
| Security and QoS | `06-policy-qos-hardening/`, workbook 16, 24, 31, 34, 37 | Add platform-validated first-hop security, queue scheduling and policy counter labs |
| Automation and assurance | `06-security-operations/` | Expand reproducible API error, authorization, telemetry and rollback exercises |
| Overlays, VPNs and fabrics | `07-a-overlays-tunnels/`, `07-b-fabrics-multi-area/`, workbook 18–19 and 33 | Audit standards-based tunnel, MPLS and overlay troubleshooting; product-specific VPN designs require their own documentation |

Keep this list as a working audit, not a completeness claim. Link every added topic to tested evidence where possible and document gaps and platform dependencies when it is not.
