#!/bin/bash
# Adds a harmless cron job to current user's crontab (persistence simulation).
set -e

echo "[+] Adding harmless cron persistence entry for user: $(whoami)"
( crontab -l 2>/dev/null; echo "*/5 * * * * echo 'persistence_test' >> /tmp/cron_persist.log" ) | crontab -

echo "[+] Current crontab:"
crontab -l
