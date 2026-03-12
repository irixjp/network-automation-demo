set -e

sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

for i in 1 2 3 4 5 6; do
  for t in $(seq 1 50); do
    ip link show "eth${i}" >/dev/null 2>&1 && break
    sleep 0.2
  done
  ip link show "eth${i}" >/dev/null 2>&1 || {
    echo "Interface eth${i} not found (timeout)"
    exit 1
  }
done

ip link set lo up

ip link set eth1 up
ip addr add 10.255.10.0/31 dev eth1
ip link set eth2 up
ip addr add 10.255.0.1/31 dev eth2
ip link set eth3 up
ip addr add 10.255.0.5/31 dev eth3
ip link set eth4 up
ip addr add 10.255.1.1/31 dev eth4
ip link set eth5 up
ip addr add 10.255.1.5/31 dev eth5
ip link set eth6 up
ip addr add 10.255.1.9/31 dev eth6

ip addr add 10.255.0.41/32 dev lo

exec /usr/lib/frr/docker-start
