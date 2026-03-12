#!/bin/sh
set -eu

GIT_PASSWORD="${GIT_PASSWORD:-git}"
REPO_PATH="/srv/git/ansible-evidence.git"

echo "git:${GIT_PASSWORD}" | chpasswd

if [ -f /config/authorized_keys ]; then
  install -d -m 700 /home/git/.ssh
  install -m 600 /config/authorized_keys /home/git/.ssh/authorized_keys
  chown -R git:git /home/git/.ssh
fi

ssh-keygen -A

if [ ! -d "${REPO_PATH}" ]; then
  git init --bare --initial-branch=main "${REPO_PATH}"
  chown -R git:git "${REPO_PATH}"
fi

cat >/etc/ssh/sshd_config <<'EOF'
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
AllowUsers git
UsePAM no
ChallengeResponseAuthentication no
Subsystem sftp /usr/lib/ssh/sftp-server
EOF

exec /usr/sbin/sshd -D -e
