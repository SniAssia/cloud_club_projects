#!/bin/bash
set -e

MONITOR="/usr/local/bin/monitoring.sh"

cat << 'EOF' > $MONITOR
#!/bin/bash
wall "Monitoring report"
EOF

chmod +x $MONITOR

(crontab -l 2>/dev/null | grep -q "$MONITOR") || \
  (crontab -l 2>/dev/null; echo "*/10 * * * * $MONITOR") | crontab -
