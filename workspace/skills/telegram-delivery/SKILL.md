---
name: telegram-delivery
version: 1.0.0
description: "Sends formatted weather report to Telegram using native message tool"
user-invocable: false
metadata:
  openclaw:
    requires:
      bins: [python3]
      env: [TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID]
    native_tool: message
---

# Telegram Delivery

Sends the formatted weather message to Telegram and logs delivery to the database.

## Input

`/tmp/weather_formatted_${RUN_ID}.txt` — Formatted message from weather-formatter

## Output

Database write to `result_weather_deliveries`

## Execution

```bash
{baseDir}/scripts/run.sh
```
