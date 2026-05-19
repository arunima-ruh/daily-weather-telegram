---
name: weather-fetcher
version: 1.0.0
description: "Fetches daily weather forecast for Sasaram using WebSearch tool"
user-invocable: false
metadata:
  openclaw:
    requires:
      bins: [jq]
      env: [LOCATION]
    native_tool: WebSearch
---

# Weather Fetcher

Fetches weather data using OpenClaw's native WebSearch tool (no API key required).

## Input

None (reads LOCATION from environment, defaults to "Sasaram")

## Output

`/tmp/weather_${RUN_ID}.json` — Raw weather data

```json
{
  "location": "Sasaram",
  "date": "2026-03-31",
  "temperature_high": 32,
  "temperature_low": 21,
  "conditions": "Partly cloudy",
  "precipitation_chance": 10,
  "wind_speed": 15,
  "wind_direction": "NW"
}
```

## Execution

```bash
{baseDir}/scripts/run.sh
```
