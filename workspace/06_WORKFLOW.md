# 06 — Workflow

## Workflow Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                    Daily Weather Report Pipeline                  │
└──────────────────────────────────────────────────────────────────┘

Phase 1: Database Setup
  provision-database ← [Auto]
    ↓

Phase 2: Data Acquisition
  fetch-weather (WebSearch tool) ← [Auto]
    ↓

Phase 3: Formatting
  format-message ← [Auto]
    ↓

Phase 4: Delivery & Logging
  deliver-telegram (message tool) ← [Auto]
    ├─ Send to Telegram
    └─ Write to result_weather_deliveries
```

## Exception Handling

| Exception | Action |
|---|---|
| WebSearch returns no data | Skip delivery, log error |
| Telegram delivery fails | Set delivery_status="failed" in database |
| Database unavailable | Continue with delivery, skip logging |
| Malformed weather data | Log error, skip formatting and delivery |

## Retry Policy

- **WebSearch failures:** No automatic retry (will retry on next scheduled run)
- **Telegram failures:** No automatic retry (logged as failed delivery)
- **Database failures:** No retry (database is optional)
