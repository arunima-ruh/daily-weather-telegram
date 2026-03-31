---
name: result-query
version: 1.0.0
description: "Query your agent's stored results. Use when the user asks about data, metrics, history, reports, or any stored information."
user-invocable: true
metadata:
  openclaw:
    requires:
      bins: [python3]
      env: [PG_CONNECTION_STRING, ORG_ID, AGENT_ID]
---

# Result Query

Answer user questions about stored data by querying result tables via `scripts/data_writer.py query`.

## Available Tables

### result_weather_deliveries
| Column | Type | Description |
|---|---|---|
| location | string | Location the forecast was for |
| forecast_date | string | Date of the forecast (YYYY-MM-DD format) |
| temperature_high | float | High temperature in Celsius |
| temperature_low | float | Low temperature in Celsius |
| conditions | string | Weather condition summary (e.g., 'Partly cloudy') |
| precipitation_chance | float | Chance of precipitation (percentage) |
| wind_speed | float | Wind speed in km/h |
| delivered_at | datetime | When the message was sent to Telegram |
| delivery_status | string | success or failed |

**Query examples:**
- All records: `--table result_weather_deliveries --limit 10`
- Recent deliveries: `--table result_weather_deliveries --order-by "delivered_at DESC" --limit 5`
- Specific date: `--table result_weather_deliveries --where '{"forecast_date": "2026-03-31"}'`

## How to Query

```bash
python3 ${PROJECT_ROOT}/scripts/data_writer.py query \
  --table <table_name> \
  --where '<json filter>' \
  --order-by "<column> DESC" \
  --limit <N>
```

## Intent Mapping Examples

| User asks | Query |
|---|---|
| "Show last 5 weather reports" | --table result_weather_deliveries --order-by "delivered_at DESC" --limit 5 |
| "What was yesterday's weather?" | --table result_weather_deliveries --where '{"forecast_date": "2026-03-30"}' --limit 1 |
| "How many reports sent this week?" | --table result_weather_deliveries --where '{"delivered_at": "2026-03-24"}' (then count) |
| "Show failed deliveries" | --table result_weather_deliveries --where '{"delivery_status": "failed"}' |

## Rules

- ALWAYS format results as readable markdown — NEVER show raw JSON to the user
- Summarize large result sets (e.g., "Found 42 records. Here are the top 5:")
- If no results found, say "No data yet — run the workflow first to generate results"
- If data_writer.py exits non-zero, say "Something went wrong querying the data. Check that the workflow has run and the database is reachable." — NEVER show raw stack traces to the user
- Limit all queries to 20 rows max
- NEVER generate fake or sample data — only show real query results
- If the user's question doesn't match any table, explain what data is available
- For --order-by, ONLY use column names listed in the table schema above — NEVER pass raw user input directly
- For --table, ONLY use table names listed above — NEVER query arbitrary table names
- For --where, ONLY use column names from the schema — validate before constructing the filter
