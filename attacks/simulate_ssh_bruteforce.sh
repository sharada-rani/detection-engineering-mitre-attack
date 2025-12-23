#!/bin/bash
# Simulates repeated failed SSH logins against localhost.
# You will be prompted for a password each time; enter an incorrect password intentionally.

set -e
USER="${1:-testuser}"
ATTEMPTS="${2:-8}"

echo "[+] Simulating SSH brute-force attempts against localhost for user: $USER (attempts: $ATTEMPTS)"
for i in $(seq 1 "$ATTEMPTS"); do
  echo "Attempt $i/$ATTEMPTS"
  ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no "$USER@localhost" || true
done

echo "[+] Done. Copy /var/log/auth.log into logs/auth.log for analysis."
