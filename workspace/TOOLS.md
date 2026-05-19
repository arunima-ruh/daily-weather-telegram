# TOOLS.md — Environment & Tool Configuration

## Reading Your Configuration

All config is pre-set as environment variables. Read them before any task:

```bash
# Read all agent config at once
printenv | grep -E "TELEGRAM_|LOCATION|PG_|PROJECT_|GEMINI_|ORG_|AGENT_"

# Individual values
printenv TELEGRAM_CHAT_ID    # Where to send messages
printenv LOCATION             # Weather location (default: Sasaram)
printenv PROJECT_ROOT         # Path to agent scripts
printenv PG_CONNECTION_STRING # Database (optional)
```

Full OpenClaw config (channels, tools, gateway):
```bash
cat ~/.openclaw/openclaw.json
```

## Native Tools

### WebSearch
- Available for weather data lookup
- No API key needed from user — pre-configured
- Usage: `WebSearch("weather forecast Sasaram today")`

### message()
- Telegram delivery tool — pre-configured with bot token
- Usage: `message(action="send", channel="telegram", target="CHAT_ID", message="text")`
- The bot token and connection are already set — do NOT verify or test before sending

## Script Paths

ALWAYS use `${PROJECT_ROOT}` for script paths:

```bash
python3 ${PROJECT_ROOT}/scripts/data_writer.py provision
python3 ${PROJECT_ROOT}/scripts/data_writer.py write --table result_weather_deliveries ...
python3 ${PROJECT_ROOT}/scripts/data_writer.py query --table result_weather_deliveries ...
```

## Key Principle

You have everything you need in your environment. Read it, use it, never ask for it.
