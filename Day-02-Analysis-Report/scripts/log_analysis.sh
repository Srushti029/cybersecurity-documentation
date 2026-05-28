#!/bin/bash
# ==============================================================================
# SECURITY OPERATIONS CENTER (SOC) LOG PARSING & TRIAGE UTILITY
# ==============================================================================
# Script Name : log_analysis.sh
# Version     : 1.0.0
# Author      : Srushti029
# Objective   : Automates the ingestion, parsing, and correlation of 
#               unstructured system logs to discover active brute-force vectors.
# Lifecycle   : Triage -> Intelligence Extraction -> Timeline Correlation
# ==============================================================================

# Strict Error Handling
set -euo pipefail

# Operational Parameters
LOG_FILE="Linux_2k.log"
REPORT_OUTPUT="evidence/automated_triage_report.txt

# Ensure environment state allows logging
mkdir -p evidence

# Redirect output tracking descriptor for historical logging
exec > >(tee -i "$REPORT_OUTPUT")
exec 2>&1

# ==============================================================================
# 1. PRE-FLIGHT VALIDATION MODULE
# ==============================================================================
echo "======================================================================"
echo " SECURITY INFRASTRUCTURE LOG ANALYSIS RUNTIME"
echo " Execution Timestamp: $TIMESTAMP"
echo "======================================================================"

if [ ! -f "$LOG_FILE" ]; then
    echo "[-] [CRITICAL_ERROR] Target artifact '$LOG_FILE' missing from runtime directory."
    echo "[-] Operational Abort."
    exit 1
fi

echo "[+] Target file status verified: $LOG_FILE (Active)"
echo "[+] Output pipe initialized: $REPORT_OUTPUT"

# ==============================================================================
# 2. ANALYSIS PHASE I: QUANTITATIVE RECONNAISSANCE
# ==============================================================================
echo -e "\n[+] METRIC COLLECTION: QUANTIFYING THREAT VOLUME"
echo "----------------------------------------------------------------------"
echo "[*] Querying database for specific string: 'authentication failure'..."

TOTAL_FAILURES=$(grep "authentication failure" "$LOG_FILE" | wc -l)

echo -e "\n>> [ALERT] Total Authentication Anomalies Located: $TOTAL_FAILURES"
echo "----------------------------------------------------------------------"

# ==============================================================================
# 3. ANALYSIS PHASE II: SOURCE ADVERSARIAL PROFILING
# ==============================================================================
echo -e "\n[+] THREAT INTELLIGENCE: ISOLATING HIGH-VOLUME THREAT VECTORS"
echo "----------------------------------------------------------------------"
echo "[*] Parsing data fields to extract unique remote hosts (rhosts)..."
echo "[*] Aggregating malicious signatures..."
echo ""
echo " Hit Count | Vector Footprint & Target Profile Data Strings"
echo " ----------+----------------------------------------------------------"

grep "authentication failure" "$LOG_FILE" | awk '{print $(NC)}' | sort | uniq -c | sort -nr | head -n 10 | while read -r count data; do
    printf "  %-8s | %s\n" "$count" "$data"
done

echo " ----------+----------------------------------------------------------"
echo "[*] Insight: Identify outliers above standard threshold for firewall ingestion."
echo "----------------------------------------------------------------------"

# ==============================================================================
# 4. ANALYSIS PHASE III: TIMELINE CRITICAL CORRELATION
# ==============================================================================
echo -e "\n[+] CORRELATION ENGINE: INTERLEAVING TIMELINE EVENT SEQUENCES"
echo "----------------------------------------------------------------------"
echo "[*] Mapping chronological distribution of authentication attempts."
echo "[*] Evaluating failures against subsequent 'session opened' validations..."
echo ""

# Format log output chunks to mimic an enterprise SIEM report window
printf "%-12s | %-8s | %-15s | %s\n" "Timestamp" "Host" "Service/Process" "Payload Message"
echo "-------------+----------+-----------------+-----------------------------------"

grep -E "authentication failure | session opened" "$LOG_FILE" | head -n 15 | while read -r line; do
    # Extract fields based on standard system spacing logs
    ts_month=$(echo "$line" | awk '{print $1}')
    ts_day=$(echo "$line" | awk '{print $2}')
    ts_time=$(echo "$line" | awk '{print $3}')
    host=$(echo "$line" | awk '{print $4}')
    process=$(echo "$line" | awk '{print $5}')
    message=$(echo "$line" | cut -d' ' -f6-)
    
    printf "%-12s | %-8s | %-15s | %s\n" "$ts_month $ts_day $ts_time" "$host" "$process" "$message"
done

echo "-------------+----------+-----------------+-----------------------------------"
echo "[*] Operational Warning: Displaying top 15 correlated events for assessment."
echo "----------------------------------------------------------------------"

# ==============================================================================
# 5. POST-EXECUTION TEARDOWN & LOG CLOSURE
# ==============================================================================
echo -e "\n======================================================================"
echo "✅ TRIAGE ANALYSIS RUNTIME COMPLETE"
echo " [SUCCESS] Automated export saved permanently to: $REPORT_OUTPUT"
echo "======================================================================"
