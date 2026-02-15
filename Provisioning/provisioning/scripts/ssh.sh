#!/bin/bash
set -e

SSH_CONFIG="/etc/ssh/sshd_config"

# Set SSH port
sed -i 's/^#Port 22/Port 1111/' $SSH_CONFIG
grep -q "^Port 1111" $SSH_CONFIG || echo "Port 1111" >> $SSH_CONFIG

# Disable root login
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' $SSH_CONFIG
grep -q "^PermitRootLogin no" $SSH_CONFIG || echo "PermitRootLogin no" >> $SSH_CONFIG

systemctl restart ssh
