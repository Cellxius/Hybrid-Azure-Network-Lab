#!/usr/bin/env bash
# Usage: ./sanitize.sh infile outfile
sed -E \
  -e 's/104\.9\.148\.199/<ONPREM_PUBLIC_IP>/g' \
  -e 's/104\.9\.148\.1/<ISP_GATEWAY>/g' \
  -e 's/a8:40:f8:1d:19:c0/<GATEWAY_MAC>/gI' \
  -e 's/D93LE5AU300157/<SERIAL>/g' \
  -e 's/2001:506:[0-9a-f:]+/<IPV6_PREFIX>/gI' \
  "$1" > "$2"
