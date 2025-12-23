#!/bin/bash
set -e
source "$(dirname "$0")/_alert.sh"

# Check current user's crontab for suspicious patterns.
CRON_TMP="/tmp/current_crontab.txt"
crontab -l 2>/dev/null > "$CRON_TMP" || true

if [ ! -s "$CRON_TMP" ]; then
  emit_alert "INFO" "Cron Persistence Check" "T1053.003" "No user crontab entries found for $(whoami)."
  exit 0
fi

# Simple heuristics: suspicious keywords and unusual executables.
SUSP_RE='(curl|wget|nc |netcat|bash -i|python -c|perl -e|/dev/tcp|base64|chmod \+x|mkfifo|socat|nohup|crontab -r)'
if grep -Eqi "$SUSP_RE" "$CRON_TMP"; then
  hit="$(grep -Eai "$SUSP_RE" "$CRON_TMP" | tr -d '\r' | head -n 5)"
  emit_alert "HIGH" "Cron Job Persistence" "T1053.003" "Suspicious crontab entries detected for $(whoami): $hit"
else
  emit_alert "LOW" "Cron Persistence" "T1053.003" "User crontab exists but no suspicious patterns matched."
fi

# Also check for the specific lab persistence marker
if grep -q "persistence_test" "$CRON_TMP"; then
  emit_alert "MEDIUM" "Cron Persistence (Lab Marker)" "T1053.003" "Detected lab persistence marker writing to /tmp/cron_persist.log."
fi
