#!/usr/bin/env bash
# Stop all hourly Azure billing for the hybrid lab
RG="rg-hybrid-lab"
az network vpn-connection delete -g $RG -n cn-to-onprem 2>/dev/null
az network vnet-gateway delete -g $RG -n vpngw-hub --no-wait
az vm deallocate -g $RG -n vm-spoke01 --no-wait
echo "Gateway deleting, VM deallocating."
echo "Still billing: pip-vpngw and vm-spoke01 disk (a few cents/month)."
