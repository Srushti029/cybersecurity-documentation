# SPL Query Cheat Sheet
*Built during Splunk SIEM lab · SOC Analyst Training*

---

## Basics

| Purpose | SPL |
|---|---|
| Search all indexes | `index=*` |
| Filter by sourcetype | `index=* sourcetype="soc1"` |
| Filter by field value | `index=* Category="Malware & Threat"` |
| Search within time range | Use the time picker UI or `earliest=-24h latest=now` |

---

## Stats & Aggregation

```spl
# Count events by a field
| stats count by "Attack Type"

# Count + sort descending
| stats count by Category
| sort -count

# Count + sort + limit to top 10
| stats count by "Tools Used"
| sort -count
| head 10

# Multiple aggregations
| stats count, dc("Attack Type") as unique_types by Category
```

---

## Field Operations

```spl
# Profile all fields in dataset
| fieldsummary

# Rename a field
| rename "Attack Type" as attack_type

# Keep only specific fields
| table Category, "Attack Type", count

# Remove a field
| fields - _raw
```

---

## Filtering

```spl
# WHERE-style filter
| where count > 10

# Search keyword in any field
index=* "SQL Injection"

# Exclude a value
index=* NOT Category="Unknown"

# Multiple conditions
index=* Category="Malware & Threat" "Target Type"="Windows"
```

---

## Transforming Results

```spl
# Percentage of total
| stats count by Category
| eventstats sum(count) as total
| eval pct = round(count/total*100, 2)
| sort -pct

# Concatenate fields
| eval summary = Category + " → " + "Attack Type"
```

---

## Useful One-Liners

```spl
# Top 10 attack types
index=* | top limit=10 "Attack Type"

# Rare attack types (long tail)
index=* | rare limit=10 "Attack Type"

# Event count over time
index=* | timechart count by Category

# Distinct count of attack types per category
index=* | stats dc("Attack Type") as unique_attacks by Category | sort -unique_attacks
```

---

## Dashboard Panel Queries (Used in This Lab)

```spl
# Panel 1 — Top Attack Types
index=* | stats count by "Attack Type" | sort -count

# Panel 2 — Tools Used in Attacks
index=* | stats count by "Tools Used" | sort -count

# Panel 3 — Attack Categories
index=* | stats count by Category | sort -count

# Panel 4 — Detection Methods
index=* | stats count by "Detection Method" | sort -count
```

---

## Tips

- Always use **quotes** for multi-word field names: `"Attack Type"` not `Attack Type`
- `sort -count` = descending, `sort count` = ascending
- `head N` limits results to N rows
- `fieldsummary` is great for quickly understanding a new dataset
- Time range selector overrides `earliest`/`latest` in the UI
