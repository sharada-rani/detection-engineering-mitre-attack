#!/bin/bash
set -e
source "$(dirname "$0")/_alert.sh"

LOG_FILE="$(dirname "$0")/../logs/auth.log"
THRESHOLD="${1:-5}"

if [ ! -f "$LOG_FILE" ]; then
  emit_alert "INFO" "SSH Brute Force" "T1110" "No logs/auth.log found. Copy /var/log/auth.log to logs/auth.log."
  exit 0
fi

# Count failed password attempts per source IP.
# Typical auth.log line includes: "Failed password ... from <IP> port ..."
mapfile -t results < <(grep -E "Failed password" "$LOG_FILE" | awk '{for(i=1;i<=NF;i++) if ($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr)

if [ "${#results[@]}" -eq 0 ]; then
  emit_alert "INFO" "SSH Brute Force" "T1110" "No 'Failed password' events found in logs/auth.log."
  exit 0
fi

for line in "${results[@]}"; do
  count="$(echo "$line" | awk '{print $1}')"
  ip="$(echo "$line" | awk '{print $2}')"
  if [ "$count" -ge "$THRESHOLD" ]; then
    emit_alert "HIGH" "SSH Brute Force / Password Guessing" "T1110" "IP $ip has $count failed SSH logins (threshold=$THRESHOLD)."
  else
    emit_alert "LOW" "SSH Failed Logins" "T1110" "IP $ip has $count failed SSH logins (below threshold=$THRESHOLD)."
  fi
done
