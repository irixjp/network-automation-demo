#!/bin/sh
set -eu

ssh-keygen -A

cat >/etc/ssh/sshd_config <<'EOF'
Port 22
Protocol 2
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication no
UsePAM no
ChallengeResponseAuthentication no
Subsystem sftp /usr/lib/ssh/sftp-server
EOF

/usr/sbin/sshd -e

# Wait for eth1 to appear before running bootstrap.
if [ -f /bootstrap.sh ]; then
  for t in $(seq 1 120); do
    ip link show eth1 >/dev/null 2>&1 && break
    sleep 1
  done
  if ip link show eth1 >/dev/null 2>&1; then
    sh /bootstrap.sh || echo "bootstrap failed (continuing)"
  else
    echo "eth1 not found (timeout), skipping bootstrap"
  fi
fi

exec sleep infinity
