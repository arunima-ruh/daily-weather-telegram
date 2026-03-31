# 04 — Agent Triggers

## Conversational Triggers

| # | Trigger Pattern | Response |
|---|---|---|
| 1 | User asks about weather history | Execute result-query skill |
| 2 | User requests manual weather report | Run workflow on-demand |

## Scheduled Triggers

| # | Schedule | Action | Timezone | Enabled |
|---|---|---|---|---|
| 1 | Daily at 8:00 AM IST (2:30 AM UTC) | Run daily-weather workflow | UTC | ✅ Yes |

**Cron Expression:** `30 2 * * *`

## Heartbeat Monitors

None (no health checks required)

## Webhook Triggers

None (no external webhook endpoints)

## Summary

- **Conversational:** 2 patterns
- **Scheduled:** 1 cron job
- **Heartbeat:** 0
- **Webhook:** 0
- **Total Triggers:** 3
