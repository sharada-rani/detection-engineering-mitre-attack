#!/bin/bash
# Starts a local netcat listener as a "suspicious" service for detection.
# Run this in one terminal; stop with CTRL+C.

PORT="${1:-4444}"
echo "[+] Starting netcat listener on port $PORT (CTRL+C to stop)"
nc -lvnp "$PORT"
