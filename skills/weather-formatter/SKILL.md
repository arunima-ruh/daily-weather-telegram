---
name: weather-formatter
version: 2.0.0
description: "Enhanced weather formatter with comprehensive 5-day forecast and current conditions"
user-invocable: false
metadata:
  openclaw:
    requires:
      bins: [jq, curl, date]
      env: [LOCATION]
---

# Enhanced Weather Formatter v2.0

Formats weather data into a comprehensive Telegram message with:
- Current conditions with detailed metrics
- Today's full forecast with temperature range
- 5-day weather outlook
- Intelligent weather advice and alerts
- Visual formatting with emojis

## Environment Variables

- `RUN_ID` — Unique identifier for this run
- `LOCATION` — Weather location (e.g., "Sasaram", "Delhi")

## Output

`/tmp/weather_formatted_${RUN_ID}.txt` — Enhanced formatted message ready for delivery

## Features

- **Current Conditions**: Real-time temperature, feels-like, humidity, wind, pressure, UV index
- **Today's Forecast**: Temperature range, precipitation chance, sunrise/sunset
- **5-Day Outlook**: Daily temperature ranges and weather conditions
- **Weather Advice**: Heat alerts, UV warnings, rain notifications
- **Rich Formatting**: Emojis, visual separators, clear sections

## Execution

```bash
{baseDir}/scripts/run.sh
```

The main script automatically uses the enhanced production formatter for reliable daily weather reports.