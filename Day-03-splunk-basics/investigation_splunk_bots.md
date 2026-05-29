# SIEM Lab: Splunk Investigation Summary

**Date:** May 29, 2026  
**Phase:** SOC Analyst Training  
**Tool:** Splunk Enterprise (local install)  
**Dataset:** Custom Attack Dataset (14,133 events · 63 attack categories · 8,833+ unique attack types)

---

## Objective

Set up Splunk, ingest a real-world-style cybersecurity attack dataset, write SPL queries to surface threat patterns, and build a SOC analyst dashboard.

---

## Environment Setup

- Installed **Splunk Enterprise** locally
- Ingested `Attack_Dataset.csv` as sourcetype `soc1`
- Dataset fields: `Attack Type`, `Category`, `Tools Used`, `Detection Method`, `Target Type`, `MITRE Technique`, `Impact`, `Solution`

---

## SPL Queries Written

### 1. Count events by Attack Type (sorted descending)
```spl
index=* 
| stats count by "Attack Type"
| sort -count
```
**Finding:** 8,833 unique attack types detected across 14,433 events.

---

### 2. Top Tools Used in Attacks
```spl
index=* 
| stats count by "Tools Used"
| sort -count
```
**Top results:**
| Tools Used | Count |
|---|---|
| Velociraptor | 18 |
| KAPE | 17 |
| Remix IDE, Ganache, Metamask, Hardhat, ethers.js | 17 |
| SDR, GPS Simulator | 17 |
| Burp Suite, Browser Dev Tools | 14 |
| CMD | 14 |

---

### 3. Field Summary (Data Profiling)
```spl
index=* sourcetype="soc1" 
| fieldsummary
```
**Finding:** 25 fields parsed. `Target Type` has 500 distinct values across 14,129 events. Top targets include Windows, Workstation, Satellite, Endpoint, Android App.

---

### 4. Attack Categories Distribution
```spl
index=* 
| stats count by Category
| sort -count
```
**Top Categories:**
| Category | Count |
|---|---|
| Insider Threat | 569 |
| Physical / Hardware Attacks | 548 |
| Quantum Cryptography & Post-Quantum Threats | 542 |
| Wireless Attacks (Advanced) | 535 |
| Malware & Threat | 528 |
| Satellite & Space Infrastructure Security | 515 |

---

## Dashboard Built: *SOC Threat Analysis Dashboard*

4 panels created in Splunk:

| Panel | Chart Type | SPL Basis |
|---|---|---|
| Top Attack Types | Horizontal Bar | `stats count by "Attack Type"` |
| Tools Used in Attacks | Pie Chart | `stats count by "Tools Used"` |
| Sorted By Categories | Pie Chart | `stats count by Category` |
| Detection Methods | Bar Chart | `stats count by "Detection Method"` |

---

## Key Findings

- **Broadest threat surface:** Insider Threat is the #1 category (569 events), followed closely by Physical/Hardware Attacks — highlighting that not all threats are network-based.
- **Emerging threats prominent:** Quantum Cryptography, AI/ML Security, Satellite & Space Infrastructure all appear in the top categories — this dataset reflects next-generation attack surfaces.
- **Forensic tools dominant:** Velociraptor and KAPE (top tools) are DFIR/forensics tools — suggesting many scenarios involve post-breach investigation, not just attack execution.
- **Detection is highly distributed:** Hundreds of distinct detection methods — no single silver bullet, reinforcing the need for layered defense.

---

## Skills Demonstrated

- Splunk installation and data ingestion
- SPL: `stats`, `sort`, `fieldsummary`, `index` filtering
- Dashboard creation with multiple visualization types
- Threat categorization and pattern recognition from raw data
- MITRE ATT&CK familiarity (dataset includes technique mappings)

---
