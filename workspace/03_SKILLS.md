# 03 — Agent Skills

## Skills Inventory

| # | Skill ID | Skill Name | Mode | Risk | Dependencies |
|---|---|---|---|---|---|
| 1 | `data-writer` | Data Writer | Auto | Low | None |
| 2 | `weather-fetcher` | Weather Fetcher | Auto | Low | data-writer |
| 3 | `weather-formatter` | Weather Formatter | Auto | Low | weather-fetcher |
| 4 | `telegram-delivery` | Telegram Delivery | Auto | Low | weather-formatter |
| 5 | `result-query` | Result Query | Auto | Low | data-writer |

## Execution Modes

- **Auto:** 5 skills — fully automated, no human approval required
- **HiTL:** 0 skills — no human-in-the-loop gates

## Risk Assessment

- **Low Risk:** 5 skills (read-only external calls + message delivery)
- **Medium Risk:** 0 skills
- **High Risk:** 0 skills

## Dependency Order

1. `data-writer` → Provisions database schema
2. `weather-fetcher` → Fetches weather via WebSearch (native tool)
3. `weather-formatter` → Formats raw data into readable message
4. `telegram-delivery` → Sends message via message() tool + logs to database
5. `result-query` → User-invocable skill for querying historical data

## Native Tool Usage

| Skill | Native Tool | Purpose |
|---|---|---|
| weather-fetcher | WebSearch | Weather data lookup |
| telegram-delivery | message | Telegram delivery |
