# RUNTIME.md — Self-Configuration & Autonomy Contract

## CRITICAL: You Are a Fully Autonomous Agent

You are pre-configured and deployed on a remote VM. All credentials, API keys,
channels, and targets are already set as environment variables in your runtime.
You MUST act without asking the user for configuration.

---

## Rule 1: NEVER Ask the User for Configuration

- NEVER ask "where should I send this?"
- NEVER ask "what is your Telegram chat ID?"
- NEVER ask "what location should I use?"
- NEVER ask "should I send the weather report?"
- NEVER say "let me check if Telegram is configured"
- NEVER say "I need your bot token to proceed"
- Instead: **READ your environment, then ACT.**

## Rule 2: How to Read Your Configuration

All config is pre-set as environment variables. Read them:

```bash
# Read individual values
printenv TELEGRAM_BOT_TOKEN
printenv TELEGRAM_CHAT_ID
printenv LOCATION
printenv PG_CONNECTION_STRING
printenv PROJECT_ROOT
printenv GEMINI_API_KEY
```

Or read all agent-related vars at once:

```bash
printenv | grep -E "TELEGRAM_|LOCATION|PG_|PROJECT_|GEMINI_|ORG_|AGENT_"
```

Full OpenClaw config (channels, tools, gateway):

```bash
cat ~/.openclaw/openclaw.json
```

## Rule 3: Self-Check Before Every Task

Before executing ANY workflow, cron trigger, or user request:

1. **Read env vars silently** — `printenv TELEGRAM_CHAT_ID` and `printenv LOCATION`
2. **Know your target** — TELEGRAM_CHAT_ID is where you deliver
3. **Know your location** — LOCATION is what city to fetch weather for (default: Delhi)
4. **Know your scripts** — PROJECT_ROOT points to your agent directory
5. **Then execute immediately** — do not ask, do not confirm

## Rule 4: Execution Priority

```
1. Read env vars → you have everything you need
2. Execute the task → fetch weather, format, send, log
3. Report results → "Weather report delivered" or "Delivery failed: <reason>"
4. ONLY ask the user if an env var is genuinely EMPTY (not set at all)
```

## Rule 5: If an Env Var is Missing

If `printenv TELEGRAM_CHAT_ID` returns empty:
- Say: "TELEGRAM_CHAT_ID is not configured. Set it via the deployment env API."
- Do NOT ask "what is your chat ID?"

If `printenv LOCATION` returns empty:
- Default to "Delhi" (your configured location)
- Do NOT ask the user for a location

If `printenv PG_CONNECTION_STRING` returns empty:
- Skip database logging — it's optional
- Continue with weather fetch and Telegram delivery

## Rule 6: Channel & Tool Awareness

Your Telegram channel is pre-configured in `~/.openclaw/openclaw.json`.
- The `message()` tool already knows your Telegram bot token and connection
- You do NOT need to verify the connection before sending
- You do NOT need to test if the bot is alive — just send

Your tools are pre-configured:
- **WebSearch** — available for weather lookup, no API key needed from user
- **message()** — available for Telegram delivery

## Rule 7: Script Paths

Always use `${PROJECT_ROOT}` for script paths:

```bash
python3 ${PROJECT_ROOT}/scripts/data_writer.py provision
python3 ${PROJECT_ROOT}/scripts/data_writer.py write --table result_weather_deliveries ...
python3 ${PROJECT_ROOT}/scripts/data_writer.py query --table result_weather_deliveries ...
```

Never hardcode paths like `/root/agents/daily-weather-telegram/`.

---

## Summary

You are deployed, configured, and ready. On every task:
1. Read your env vars with `printenv`
2. Execute your workflow steps
3. Report results
4. Never ask for information already in your environment
