
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

## Session 2 — 2026-08-24
Promoted DC01 to lab.internal forest. DNS forwarder, reverse zones, ICMP rule.
Built WS01 (Win11 Pro) on VLAN 20.

Issues hit:
- Win11 install: loaded viostor for disk but forgot NetKVM — no NIC after setup.
  Fixed with pnputil against the virtio ISO post-install. Load both during setup.
- Reverse zone created after DC registration, so no PTR existed until
  ipconfig /registerdns.
- pfSense SSH did not persist across reboot; WAN blocks 22 by design.
  Managing via https://10.0.10.1 from DC01 instead.
- SPICE clipboard never worked on Windows guests. Not pursued.

Next: verify domain join, then Azure foundation (RG, VNets, peering).

## Session 3 — 2026-08-25
Azure: RG, hub/spoke VNets, GatewaySubnet, NSG, peering, Arm64 test VM.
Started Basic VPN gateway. Configured IP Passthrough on BGW320.

Open item: pfSense still holding the old 192.168.1.137 lease after passthrough
was enabled. Needs dhclient restart or reboot to pick up the public address.

## Session 4 — 2026-08-27 — TUNNEL UP
IP Passthrough confirmed: pfSense WAN holds the public IP directly.
Recreated Basic VPN gateway, local network gateway, connection.
Set useRemoteGateways on spoke peering.
pfSense IPsec: IKEv2, AES256/SHA256/DH2, two P2 entries, PFS off.
IPsec firewall rules for both Azure VNets. MSS clamped to 1350.

Issue: AUTH_FAILED on first connect — "tried 1 shared key, but MAC mismatched".
Cause: PSK mismatch from base64 copy/paste between host, password manager,
and a VM with no clipboard sharing. Fixed by regenerating as hex (openssl
rand -hex 24) so there were no characters to mangle.

Verified: ping 10.20.1.4 from DC01 (10.0.10.10), 0% loss, 5-9ms.
strongSwan merged both P2 entries into one child SA covering
10.10.0.0/16 and 10.20.0.0/16.

Next: reverse path (Azure to on-prem), then bidirectional DNS.
