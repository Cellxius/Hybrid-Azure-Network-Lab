# Bidirectional DNS

## Azure -> on-prem
VNet DNS servers set to 10.0.10.10 (DC01) on both hub and spoke.
Azure VMs resolve lab.internal natively; external lookups chain
DC01 -> pfSense -> upstream.

## On-prem -> Azure
Azure's platform resolver (168.63.129.16) is reachable only from inside a
VNet. It does not answer over a VPN tunnel, so a conditional forwarder
pointed at it from on-prem silently times out.

Solution: systemd-resolved on vm-spoke01 listens on 10.20.1.4
(DNSStubListenerExtra) and forwards internal.cloudapp.net to 168.63.129.16.
DC01 conditional-forwards that zone to 10.20.1.4 across the tunnel.

Production alternative: Azure DNS Private Resolver, ~$0.27/hr per endpoint.
Rejected on cost; the forwarder achieves the same result for $0.

Note: dnsmasq was unavailable — the VM has no outbound path to the Ubuntu
mirrors with no public IP and no NAT gateway. systemd-resolved provided the
same capability with no package install.
