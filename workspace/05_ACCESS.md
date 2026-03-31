# 05 — Access Control

## Team Access

| Team | Role | Permissions |
|---|---|---|
| Personal | Owner | Full access |

## Approval Workflow

| Action Type | Approvers | Required Votes |
|---|---|---|
| Manual workflow run | None | 0 (auto-approved) |

## Model Configuration

| Parameter | Value |
|---|---|
| **Default Model** | openrouter/anthropic/claude-sonnet-4.5 |
| **Token Budget** | 1M tokens/day |
| **Thinking Mode** | Low |

## Permissions

| Permission | Granted |
|---|---|
| Read weather data | ✅ Yes |
| Send Telegram messages | ✅ Yes |
| Write to database | ✅ Yes |
| Modify agent config | ❌ No |
