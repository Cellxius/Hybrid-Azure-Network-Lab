
## VLAN bridge MTU
**Symptom:** br0.10 and br0.20 came up at MTU 1499 instead of 1500.
**Cause:** NetworkManager subtracts 4 bytes for the 802.1Q tag. Incorrect —
the tag lives in the frame header, not the payload, so MTU stays 1500.
**Impact if missed:** small packets (ping, DNS) pass fine while large frames
are silently dropped — domain join and SMB hang with no obvious cause.
**Fix:** explicitly set 802-3-ethernet.mtu 1500 on both VLAN interfaces
and their parent bridges.
