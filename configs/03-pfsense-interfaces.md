# pfSense Interface Configuration

| Interface | Type | VLAN tag | Address | Purpose |
|---|---|---|---|---|
| WAN | vtnet0 untagged | native (1) | DHCP from ISP gateway | Internet |
| VLAN10_SERVERS | vtnet0 tagged | 10 | 10.0.10.1/24 | AD DS / DNS |
| VLAN20_CLIENTS | vtnet0 tagged | 20 | 10.0.20.1/24 | Domain clients |

Single virtual NIC on br0 acts as an 802.1Q trunk — router-on-a-stick.
Tagging is consistent across three layers: 2960G Gi0/2, Linux bridge br0, pfSense vtnet0.

DHCP: VLAN20 only, 10.0.20.100-200. VLAN10 static.
Firewall: permissive pass rules on both VLANs during build; tightened in Phase 5.

Platform mitigations applied:
- Hardware checksum / TSO / LRO offload disabled (virtio + FreeBSD known issue)
- RFC1918 blocking disabled on WAN (WAN is behind NAT on private space)
