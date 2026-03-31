# 🌤️ Daily Weather Telegram Bot

## Agent Overview

| Field            | Value                          |
|------------------|--------------------------------|
| **Agent Name**   | Daily Weather Telegram Bot     |
| **Agent ID**     | `daily-weather-telegram`       |
| **Version**      | 1.0.0                          |
| **Avatar**       | 🌤️                             |
| **Tone**         | Friendly and informative       |
| **Scope**        | Daily weather forecast delivery for Delhi via Telegram |
| **Automation Type** | Data pipeline with scheduled delivery |
| **Schedule**     | Daily at 8:00 AM IST (2:30 AM UTC) |

## Greeting Message

```
🌤️ Hi! I'm your Daily Weather Bot. I send weather forecasts for Delhi every morning at 8:00 AM IST.

You can also ask me about past weather reports anytime!
```

## Agent File Structure

```
daily-weather-telegram/
├── README.md
├── openclaw.json
├── result-schema.yml
├── requirements.txt
├── .env.example
├── env-manifest.yml
├── .gitignore
├── check-environment.sh
├── install-dependencies.sh
├── test-workflow.sh
├── scripts/
│   └── data_writer.py
├── cron/
│   └── daily-weather.json
├── workspace/
│   ├── SOUL.md
│   ├── 01_IDENTITY.md
│   ├── 02_RULES.md
│   ├── 03_SKILLS.md
│   ├── 04_TRIGGERS.md
│   ├── 05_ACCESS.md
│   ├── 06_WORKFLOW.md
│   ├── 07_REVIEW.md
│   └── skills/
│       ├── data-writer/
│       ├── weather-fetcher/
│       ├── weather-formatter/
│       ├── telegram-delivery/
│       └── result-query/
├── skills/ (top-level copies)
└── workflows/
    └── main.yaml
```

## Quick Stats

| Metric              | Count            |
|---------------------|-----------------|
| Custom Rules         | 7               |
| Total Skills         | 5               |
| Skills (Auto)        | 5               |
| Skills (HiTL)        | 0               |
| Scheduled Triggers   | 1               |
| Native Tools Used    | 2 (WebSearch, message) |

## Quick Start

### 1. Prerequisites

- Python 3.8+
- `jq` (JSON processor)
- Telegram bot token (from @BotFather)
- Telegram chat ID (from @userinfobot)

### 2. Setup

```bash
# Clone the repository
git clone <repo-url>
cd daily-weather-telegram

# Install dependencies
./install-dependencies.sh

# Configure environment
cp .env.example .env
# Edit .env with your Telegram credentials
```

### 3. Test

```bash
# Check environment
./check-environment.sh

# Run test workflow
./test-workflow.sh
```

### 4. Deploy

Add the cron job to your OpenClaw config or deploy as a standalone agent.

## Environment Variables

### Required

| Variable | Description | Example |
|---|---|---|
| `TELEGRAM_BOT_TOKEN` | Bot token from @BotFather | `123456:ABC-DEF...` |
| `TELEGRAM_CHAT_ID` | Chat ID for delivery | `-1001234567890` |

### Optional

| Variable | Description | Default |
|---|---|---|
| `LOCATION` | City for weather forecast | `Delhi` |
| `PG_CONNECTION_STRING` | PostgreSQL for audit trail | Not set (disabled) |
| `ORG_ID` | Organisation ID | `default` |
| `AGENT_ID` | Agent ID | `daily-weather-telegram` |

## Features

✅ **Daily Weather Forecast** — Automatic delivery at 8:00 AM IST  
✅ **Native Tools** — Uses WebSearch and message() (no external API keys)  
✅ **Audit Trail** — Optional PostgreSQL logging of deliveries  
✅ **Query History** — Ask "Show last 5 weather reports"  
✅ **Error Handling** — Graceful degradation if database unavailable  

## Usage

### Scheduled Delivery

The agent runs automatically every day at 8:00 AM IST via cron.

### Manual Trigger

Send a message to the agent:
```
Run the daily weather report workflow
```

### Query History

Ask the agent:
```
Show last 5 weather reports
```

## Troubleshooting

### No Telegram message received

- Check `TELEGRAM_BOT_TOKEN` is valid
- Check `TELEGRAM_CHAT_ID` is correct
- Check bot is added to the chat (if using group/channel)

### Database errors

- Database is optional — agent works without it
- If PG configured, verify `PG_CONNECTION_STRING` format
- Check database is reachable from agent host

### Wrong timezone

- Cron runs at 2:30 AM UTC = 8:00 AM IST
- Adjust cron expression if needed for different timezone

## License

MIT
