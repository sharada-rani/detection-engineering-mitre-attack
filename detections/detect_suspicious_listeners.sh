#!/bin/bash
set -e
source "$(dirname "$0")/_alert.sh"

# List listening TCP ports with process names
LISTEN_OUT="$(ss -ltnp 2>/dev/null || true)"

if [ -z "$LISTEN_OUT" ]; then
  emit_alert "INFO" "Listening Services Check" "T1049" "Could not read listening sockets (ss output empty)."
  exit 0
fi

# Flag netcat/nc listeners or non-standard high ports
if echo "$LISTEN_OUT" | grep -Eqi "(nc|netcat)"; then
  hit="$(echo "$LISTEN_OUT" | grep -Ei "(nc|netcat)" | head -n 5 | tr -d '\r')"
  emit_alert "HIGH" "Suspicious Listener (netcat)" "T1049" "Detected netcat listener(s): $hit"
fi

# Flag common “lab suspicious port” 4444 if listening
if echo "$LISTEN_OUT" | grep -Eq ":4444\b"; then
  hit="$(echo "$LISTEN_OUT" | grep -E ":4444\b" | head -n 5 | tr -d '\r')"
  emit_alert "MEDIUM" "Unexpected Listening Port" "T1049" "Port 4444 is listening: $hit"
fi

# Always log a baseline summary
open_count="$(echo "$LISTEN_OUT" | grep -c "LISTEN" || true)"
emit_alert "LOW" "Listening Services Baseline" "T1049" "Listening socket snapshot captured. LISTEN lines: $open_count"
