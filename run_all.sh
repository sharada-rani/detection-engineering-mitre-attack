#!/bin/bash
set -e
cd "$(dirname "$0")"

# refresh auth.log snapshot
sudo cp /var/log/auth.log logs/auth.log 2>/dev/null || true
sudo chown -R kali:kali logs 2>/dev/null || true

echo "[+] Running detections..."
./detections/detect_ssh_bruteforce.sh 5
./detections/detect_cron_persistence.sh
./detections/detect_suspicious_listeners.sh
./detections/detect_suspicious_processes.sh

echo "[+] Alerts written to: alerts/alerts.txt"
