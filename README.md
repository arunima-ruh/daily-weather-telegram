# Daily Weather Telegram Bot 🌤️

Autonomous weather forecast delivery agent for Delhi → Telegram.

## What This Does

- Fetches daily weather forecasts for Delhi
- Sends formatted reports to your Telegram chat  
- Runs automatically at 8:00 AM IST
- Logs delivery history to database

## Quick Start

1. **Environment configured** - All variables are pre-set via deployment
2. **Cron scheduled** - Runs daily at `30 2 * * *` UTC (8:00 AM IST)
3. **Skills ready** - Weather fetching, formatting, and delivery

## Manual Trigger

Send: "Run the daily weather report workflow" to trigger on-demand.

## Skills Overview

| Skill | Purpose |
|---|---|
| `weather-fetcher` | Get forecast via WebSearch |
| `weather-formatter` | Format into readable message |
| `telegram-delivery` | Send to Telegram + log to DB |
| `data-writer` | Database operations |
| `result-query` | Historical delivery queries |

## Configuration

All config via environment variables:
- `LOCATION` - Weather location (Delhi)
- `TELEGRAM_CHAT_ID` - Target chat
- `TELEGRAM_BOT_TOKEN` - Bot credentials
- `PG_CONNECTION_STRING` - Database (optional)

## Development

### Making Changes

**REQUIRED VALIDATION STEPS:**

1. **Update related files** - If SOUL.md changes, update AGENTS.md, README.md as needed
2. **Check OpenClaw structure** - Verify workspace files, skills, environment intact
3. **Test integration** - Confirm all systems work together
4. **Validate git safety** - No secrets, proper branch, clean history

**Git Workflow:**
```bash
cd ${PROJECT_ROOT}
git checkout -b agent/<description>

# Make changes...

# VALIDATION REQUIRED:
./validate-changes.sh  # (or manual validation steps)

# Commit only after validation passes
git add -A && git commit -m "<what changed>"
git push origin agent/<description>
```

### Validation Checklist

Before any commit:

- [ ] All configuration files updated consistently  
- [ ] OpenClaw workspace structure intact
- [ ] Environment variables still accessible
- [ ] Skills still functional
- [ ] No secrets in git history
- [ ] Natural conversation style maintained
- [ ] Integration tested

**Never push to main/master** - Always use feature branches.

## Project Structure

```
/root/.openclaw/workspace/
├── SOUL.md          # Personality & workflow rules
├── AGENTS.md        # Operating manual
├── TOOLS.md         # Tool configuration
├── README.md        # This file
├── skills/          # Weather processing skills
└── .openclaw/       # OpenClaw workspace state
```

## Support

- OpenClaw docs: https://docs.openclaw.ai
- Source: https://github.com/openclaw/openclaw
- Community: https://discord.com/invite/clawd