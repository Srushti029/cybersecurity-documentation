# Log Analysis & SSH Brute Force Detection

---

## Objective

Analyze real-world Linux system logs (`Linux_2k.log`) to detect SSH brute-force patterns, identify attacking IP addresses, correlate failed logins with successful session openings, and produce a structured incident report — simulating a real SOC Tier-1 triage workflow.

---

## Folder Structure

```
Day-02-Analysis-Report/
│
├── script/
│   └── log_analysis.sh
│
├── evidence/
│   ├── screenshot_01_log_templates.png
│   ├── screenshot_02_grep_auth_failure.png
│   ├── screenshot_03_wc_and_top_ips.png
│   └── screenshot_04_timeline_correlation.png
│
├── templates/
│   ├── failed_attempts.txt
│   └── successfull_attempts.txt
│
└── README.md
```

---

## Tools Used

| Tool | Purpose |
| --- | --- |
| `grep` | Search and filter log entries by keyword |
| `awk` | Extract specific fields from log lines |
| `sort` | Sort output for frequency ranking |
| `uniq -c` | Count unique occurrences |
| `wc -l` | Count total matching lines |
| `cut` | Extract specific columns |
| `head` / `tail` | Preview log files and templates |
| Kali Linux Terminal | Primary working environment |

---

## Tasks Performed

### Task 1 — Explore the Log Dataset

Loaded and inspected `Linux_2k.log` and its template file `Linux_2k.log_templates.csv` using `cat`, `head`, and `tail` to understand the event structure.

```bash
cat Linux_2k.log_templates.csv
head Linux_2k.log_templates.csv
tail Linux_2k.log_templates.csv
```

The template CSV contains 118 event types (E1–E118), including authentication failures at **E15–E19** and successful session opens at **E102–E103**.

---

### Task 2 — Count Total Authentication Failures

```bash
grep "authentication failure" Linux_2k.log | wc -l
```

**Result: 490 authentication failure events** detected across the log file.

---

### Task 3 — Identify Top Attacking Sources

```bash
grep "authentication failure" Linux_2k.log | awk '{print $(NF)}' | sort | uniq -c | sort -nr | head
```

Top attacking IP addresses identified:

| Count | Source IP | Target User |
| --- | --- | --- |
| 5 | `195.129.24.210` | root |
| 5 | `60.30.224.116` | root |

Both IPs targeted the `root` account via SSH (`tty=NODEVssh`), consistent with automated brute-force tooling.

---

### Task 4 — Correlate Failures with Successful Logins

```bash
grep -E "authentication failure | session opened" Linux_2k.log
```

Multiple `session opened` events were found for users `cyrus`, `news`, and `test` following failure windows — a classic brute-force success indicator. Notable entry:

```
Jun 17 20:29:26 combo sshd(pam_unix)[30631]: session opened for user test by (uid=509)
```

This session for user `test` (uid=509) opened after repeated authentication failures — flagged as a **high-confidence brute-force compromise**.

---

### Task 5 — Automated Triage with Bash Script

A full SOC triage script (`log_analysis.sh`) was written to automate the entire workflow:

- Pre-flight log validation
- Quantitative failure counting
- Adversarial IP profiling (top 10 threat vectors)
- Timeline correlation of failures vs session opens
- Evidence export to `evidence/automated_triage_report.txt`

```bash
bash script/log_analysis.sh
```

---

## Incident Report #01 — SSH Brute Force Analysis

| Field | Detail |
| --- | --- |
| **Incident ID** | INC-2026-002 |
| **Date Detected** | June 15–30 (log window) |
| **Log Source** | `Linux_2k.log` (LogHub dataset) |
| **Attack Type** | SSH Brute Force |
| **Target Host** | `combo` |
| **Target Accounts** | `root`, `guest`, `test` |
| **Attacking IPs** | `195.129.24.210`, `60.30.224.116` |
| **Total Failures** | 490 |
| **Successful After Failures** | Yes — `test` (uid=509) on Jun 17 |
| **Severity** | 🔴 HIGH |

---

### Attack Timeline

```
Jun 30  19:03:03 → 20:16:30  |  195.129.24.210  |  Multiple root login failures via SSH
Jun 30  19:03:03 → 20:16:30  |  60.30.224.116   |  Multiple root login failures via SSH
Jun 17  20:29:26             |  Internal        |  session opened for user test (uid=509)  ← COMPROMISE
```

---

###  Findings

- **490 authentication failures** found across a multi-day window — volume is consistent with automated brute-force tooling.
- Two IPs (`195.129.24.210` and `60.30.224.116`) repeatedly targeted the `root` account over SSH, suggesting a coordinated or scripted attack.
- A `session opened` event for user `test` with uid=509 was recorded on **Jun 17**, shortly after failure sequences — indicating a **successful brute-force login**.
- Failed login templates (E15–E19) show attempts against `root`, `guest`, and `test` accounts from remote hosts.

---

###  Recommended Mitigations

- Block `195.129.24.210` and `60.30.224.116` at the firewall immediately.
- Disable SSH root login — set `PermitRootLogin no` in `/etc/ssh/sshd_config`.
- Implement `fail2ban` or similar rate-limiting for SSH.
- Audit the `test` account — disable if not in active use.
- Enable SSH key-based authentication and disable password authentication.
- Review all session opens for uid=509 across the full log history.

---

## Evidence Screenshots

| # | File | Description |
| --- | --- | --- |
| 1 | `screenshot_01` | `cat` of log templates CSV — event structure overview |
| 2 | `screenshot_02` | `grep "authentication failure"` on templates — E15–E19 identified |
| 3 | `screenshot_03` | `wc -l` showing **490 failures** + top attacking IPs ranked |
| 4 | `screenshot_04` | Timeline correlation — failures + `session opened` events |

---

## Resources Referenced

- [SANS: Intrusion Detection with Log Analysis](https://www.sans.org)
- [Blue Team Labs Online — Log Analysis Room](https://blueteamlabs.online)
- [LogHub Dataset](https://github.com/logpai/loghub)

---

## Key Learnings

- `grep + awk + sort + uniq` pipelines are the backbone of manual log triage in a SOC environment.
- Correlating failure events with subsequent `session opened` entries is a reliable method for detecting successful brute-force compromises.
- Log templates (like LogHub's CSV) help normalize unstructured logs into queryable event IDs — foundational skill before moving to SIEM tools.
- Automating triage with bash scripts significantly reduces analyst response time.

---

*Part of my SOC Analyst learning journey — documented daily at [cybersecurity-doc](https://github.com/Srushti029/cybersecurity-doc)*
