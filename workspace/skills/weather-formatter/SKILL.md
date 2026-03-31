---
name: weather-formatter
version: 1.0.0
description: "Formats raw weather data into a user-friendly message"
user-invocable: false
metadata:
  openclaw:
    requires:
      bins: [jq]
---

# Weather Formatter

Formats raw weather JSON into a readable Telegram message.

## Input

`/tmp/weather_${RUN_ID}.json` — Raw weather data from weather-fetcher

## Output

`/tmp/weather_formatted_${RUN_ID}.txt` — Formatted message ready for delivery

## Execution

```bash
{baseDir}/scripts/run.sh
```
