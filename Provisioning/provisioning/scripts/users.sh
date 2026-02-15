#!/bin/bash
set -e

USERNAME="assia"

if ! id "$USERNAME" &>/dev/null; then
  useradd -m -s /bin/bash "$USERNAME"
  # should we set here another apprach to get password discretely 
  echo "$USERNAME:StrongPassword123" | chpasswd
fi

usermod -aG sudo "$USERNAME"
