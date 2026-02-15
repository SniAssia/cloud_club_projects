#!/bin/bash
set -e

LOGFILE="/var/log/sudo.log"

grep -q "$LOGFILE" /etc/sudoers || \
  echo "Defaults logfile=\"$LOGFILE\"" >> /etc/sudoers
