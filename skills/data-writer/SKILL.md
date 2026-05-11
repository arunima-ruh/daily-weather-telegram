---
name: data-writer
version: 1.0.0
description: "Writes and queries agent results via scripts/data_writer.py."
user-invocable: false
metadata:
  openclaw:
    always: true
    requires:
      bins: [python3]
      env: [PG_CONNECTION_STRING, ORG_ID, AGENT_ID]
---

# Data Writer

Handles all database operations for this agent. All writes go through this script with hardcoded safety guards.

## Provision (first run only)

```bash
python3 ${PROJECT_ROOT}/scripts/data_writer.py provision
```

## Write to result_weather_deliveries

```bash
python3 ${PROJECT_ROOT}/scripts/data_writer.py write \
  --table result_weather_deliveries \
  --conflict none \
  --run-id "${RUN_ID}" \
  --records '[{
    "location": "SASARAM",
    "forecast_date": "2026-03-31",
    "temperature_high": 32.5,
    "temperature_low": 21.0,
    "conditions": "Partly cloudy",
    "precipitation_chance": 10.0,
    "wind_speed": 15.0,
    "delivered_at": "2026-03-31T08:00:00Z",
    "delivery_status": "success"
  }]'
```

## Query result_weather_deliveries

```bash
python3 ${PROJECT_ROOT}/scripts/data_writer.py query \
  --table result_weather_deliveries \
  --limit 10 \
  --order-by "computed_at DESC"
```
