#!/bin/bash
ALERT_FILE="$(dirname "$0")/../alerts/alerts.txt"
mkdir -p "$(dirname "$ALERT_FILE")"

emit_alert () {
  local severity="$1"
  local technique="$2"
  local mitre="$3"
  local message="$4"
  local ts
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "[$ts] [$severity] [$mitre] [$technique] $message" | tee -a "$ALERT_FILE"
}
