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

The workbook contains labs for IS-IS, VRF-lite, redistribution, IPv6 SLAAC, packet mirroring, and failure drills; link these from future core chapters when their prerequisites are taught. Wireless appears only in passing and needs a foundational treatment. Expand IPv6 operations and design/change management after reviewing the existing foundations and operations chapters for overlap.

Workbook labs include illustrated topologies or links to the topology they reuse; the EVPN and BGP policy labs link to their preceding labs. The capstone outline is a project brief rather than a single topology. Keep figures synchronized with lab node names, interfaces, and addressing and follow the shared diagram standard.
