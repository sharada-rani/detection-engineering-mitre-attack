#!/bin/bash
# Runs common discovery commands to generate realistic activity.
set -e

echo "[+] Running process discovery (ps)"
ps aux > /tmp/discovery_ps.txt

echo "[+] Running network discovery (ss)"
ss -tulpn > /tmp/discovery_ss.txt 2>/dev/null || true

echo "[+] Running user/session discovery (who, last)"
who > /tmp/discovery_who.txt
last -n 5 > /tmp/discovery_last.txt 2>/dev/null || true

echo "[+] Discovery artifacts saved in /tmp/discovery_*"
