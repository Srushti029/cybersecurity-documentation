# SOC Linux Investigations — Day 1

## Overview
This repository documents my hands-on practice of Linux fundamentals for SOC (Security Operations Center) and Blue Team cybersecurity skills using OverTheWire Bandit challenges.

The focus was on understanding how Linux commands are used in real security investigations such as log analysis, file discovery, and data decoding.

---

## Objective
To build foundational Linux command-line skills used in SOC environments for:
- File and system navigation
- Log filtering and pattern detection
- File investigation and anomaly detection
- Basic data decoding and analysis

---

## What I Practiced

I completed beginner-level Linux challenges and focused on how SOC analysts use these commands in real-world investigations.

---

## Key Commands Practiced

### Basic Navigation
```bash
ls
cd
pwd
cat
Used for exploring directories and reading file contents.

Special File Handling
cat ./-
cat "./--spaces in this filename--"

Learned how Linux interprets special characters in filenames.

File Inspection
ls -la
file ./*

Used to identify hidden files and determine file types.

Search & Data Analysis
grep millionth data.txt
sort data.txt | uniq -u
strings data.txt | grep ===
base64 -d data.txt

Used for searching, filtering, and decoding data from files.

SOC Relevance

These Linux commands are directly used in SOC environments:

grep → filtering logs for suspicious activity
find → locating suspicious files in systems
strings → extracting hidden data from binaries
base64 → decoding obfuscated payloads
sort + uniq → detecting anomalies in log data
Key Learning

Linux is a core skill for SOC analysts. It enables fast investigation of logs, detection of anomalies, and analysis of compromised systems through the command line.

##Outcome

This exercise helped me understand how SOC analysts use Linux daily for real-time investigation and threat detection.
