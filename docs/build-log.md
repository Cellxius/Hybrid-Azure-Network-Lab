
## VLAN bridge MTU
**Symptom:** br0.10 and br0.20 came up at MTU 1499 instead of 1500.
**Cause:** NetworkManager subtracts 4 bytes for the 802.1Q tag. Incorrect —
the tag lives in the frame header, not the payload, so MTU stays 1500.
**Impact if missed:** small packets (ping, DNS) pass fine while large frames
are silently dropped — domain join and SMB hang with no obvious cause.
**Fix:** explicitly set 802-3-ethernet.mtu 1500 on both VLAN interfaces
and their parent bridges.

## Session 1 complete — 2026-08-23
Working: 2960G trunk (Gi0/2, VLANs 1/10/20), Linux bridges br0/br-vlan10/br-vlan20,
pfSense router-on-a-stick with VLAN10 (10.0.10.1) and VLAN20 (10.0.20.1),
DHCP on VLAN20, DC01 at 10.0.10.10 pinging its gateway across the physical trunk.

Issues hit:
- libvirt/kvm group membership needed a full reboot, not just a desktop logout
- NetworkManager set VLAN bridge MTU to 1499; corrected to 1500
- Netgate no longer publishes CE ISOs past 2.7.2 — used official mirror
- virt-install rejected `--boot uefi,cdrom,hd`; needed --cdrom for install method

Next: promote DC01 to domain controller (lab.internal), then Azure foundation.
