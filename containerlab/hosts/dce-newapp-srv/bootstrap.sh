#!/bin/sh
set -e

for t in $(seq 1 50); do
  ip link show eth1 >/dev/null 2>&1 && break
  sleep 0.2
done
ip link show eth1 >/dev/null 2>&1 || {
  echo "Interface eth1 not found (timeout)"
  exit 1
}

ip link set eth1 up
ip addr add 10.30.1.10/24 dev eth1
ip route replace default via 10.30.1.1
