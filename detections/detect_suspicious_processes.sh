#!/bin/bash
set -e
source "$(dirname "$0")/_alert.sh"

# Simple process heuristics (expand later)
SUSP_RE='(bash -i|/dev/tcp|nc -l|netcat|python -c|perl -e|socat|mkfifo|chmod \+x|curl .* \| bash|wget .* \| bash)'
PS_OUT="$(ps aux || true)"

if echo "$PS_OUT" | grep -Eqi "$SUSP_RE"; then
  hit="$(echo "$PS_OUT" | grep -Eai "$SUSP_RE" | head -n 5 | tr -d '\r')"
  emit_alert "MEDIUM" "Suspicious Process Patterns" "T1057" "Matched suspicious process pattern(s): $hit"
else
  emit_alert "LOW" "Process Monitoring" "T1057" "No suspicious process patterns matched."
fi
