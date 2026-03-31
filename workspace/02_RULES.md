# 02 — Agent Rules

## Custom Rules

| # | Rule | Enforcement |
|---|---|---|
| 1 | Only fetch weather for Delhi | Hardcoded in LOCATION env var |
| 2 | Deliver daily at 8:00 AM IST (2:30 AM UTC) | Cron schedule |
| 3 | Use native WebSearch tool for weather data | No external weather API |
| 4 | Use native message() tool for Telegram delivery | No direct Bot API calls |
| 5 | Log every delivery to database (when PG configured) | Mandatory write step |
| 6 | Format message with emoji and structured sections | Template in weather-formatter |
| 7 | Never send stale data — fetch fresh weather each run | No caching |

## Inherited Org Rules

None (standalone agent)

## Summary

- **Custom Rules:** 7
- **Inherited Org Rules:** 0
- **Total Rules:** 7
