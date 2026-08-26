# Azure Foundation

Region: South Central US (closest to San Antonio)
Resource group: rg-hybrid-lab

| Resource | Value |
|---|---|
| Hub VNet | vnet-hub, 10.10.0.0/16 |
| GatewaySubnet | 10.10.0.0/27 |
| Spoke VNet | vnet-spoke, 10.20.0.0/16 |
| Workload subnet | snet-workload, 10.20.1.0/24 |
| Test VM | vm-spoke01, 10.20.1.4, no public IP |
| NSG | nsg-workload — allow 10.0.0.0/16, deny Internet inbound |

Peering: hub-to-spoke (gateway transit enabled) <-> spoke-to-hub, both Connected.
useRemoteGateways deferred until the gateway exists — it fails otherwise.

## Issues
- Standard_B1s capacity-restricted in southcentralus. Only Arm64 (Ampere)
  B-series SKUs available; used Standard_B2pts_v2 with an arm64 Ubuntu image.
- Standard SKU public IP must be created with explicit zones (--zone 1 2 3)
  or gateway creation fails with ZRStandardIpNeeded.
- Basic VPN Gateway SKU can only be created via CLI, not the portal.
