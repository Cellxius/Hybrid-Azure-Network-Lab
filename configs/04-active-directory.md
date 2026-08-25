# Active Directory — DC01

| Setting | Value |
|---|---|
| Hostname | DC01 |
| IP | 10.0.10.10/24 static |
| Gateway | 10.0.10.1 (pfSense VLAN10) |
| DNS | 127.0.0.1 |
| Domain | lab.internal |
| NetBIOS | LAB |
| Functional level | Windows2016Domain |

Functional level 2016 is the maximum available in Server 2022 — Microsoft
introduced no new levels for 2019 or 2022.

DNS forwarder: 10.0.10.1 for external resolution.
Reverse zones: 10.0.10.0/24, 10.0.20.0/24, 10.20.1.0/24 (Azure, pre-staged).
Windows Firewall: ICMPv4 echo request inbound enabled.

## WS01 — Windows 11 Pro client, VLAN 20
DHCP 10.0.20.100, gateway 10.0.20.1, DNS 10.0.10.10 via DHCP option 6.
Verified: ping to DC across VLANs, nltest locates DC01.
