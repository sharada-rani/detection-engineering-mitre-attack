# Detection Engineering Playbook (Kali Linux)

## Objective
Design, implement, and validate custom detections mapped to MITRE ATT&CK using host telemetry on a single Linux system.

## Detections Implemented
### 1) SSH Brute Force / Password Guessing
- MITRE: T1110
- Signal: Repeated "Failed password" events in auth.log grouped by source IP
- Script: detections/detect_ssh_bruteforce.sh

### 2) Persistence via Cron
- MITRE: T1053.003
- Signal: Suspicious crontab entries (curl/wget pipelines, nc, base64, /dev/tcp, etc.)
- Script: detections/detect_cron_persistence.sh

### 3) Suspicious Listening Services
- MITRE: T1049 (discovery telemetry) / unexpected service exposure
- Signal: netcat listeners, non-standard ports (e.g., 4444)
- Script: detections/detect_suspicious_listeners.sh

### 4) Suspicious Process Patterns
- MITRE: T1057
- Signal: Process command-line patterns often used in reverse shells or downloader stagers
- Script: detections/detect_suspicious_processes.sh

## Validation Procedure
1. Run the attack simulations in attacks/
2. Run ./run_all.sh to generate alert outputs
3. Review alerts/alerts.txt and map alerts to the simulated behaviors

## Response Recommendations
- T1110: enforce key-based auth, rate-limit, fail2ban, monitor geolocation/IP reputation
- T1053.003: audit cron changes, restrict cron permissions, integrity monitoring
- Suspicious listeners: inventory allowed ports, host firewall, investigate owning process
- T1057: investigate process tree, parent-child relationships, binary provenance

## Artifacts
- alerts/alerts.txt contains all generated alerts with timestamps and technique mappings
