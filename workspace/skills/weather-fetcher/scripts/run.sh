#!/usr/bin/env bash
set -euo pipefail

# ── Env Vars ──────────────────────────────────────────────────────────────────
: "${RUN_ID:?ERROR: RUN_ID not set}"
: "${LOCATION:=Delhi}"

# ── File Paths ────────────────────────────────────────────────────────────────
OUTPUT_FILE="/tmp/weather_${RUN_ID}.json"

# ── Fetch Weather via WebSearch (native OpenClaw tool) ────────────────────────
echo "Fetching weather for ${LOCATION}..."

# The agent's SOUL.md instructs it to use the WebSearch tool here
# This script is a placeholder — the actual WebSearch call happens in the agent runtime
# For now, write a sample response (in production, the agent calls WebSearch directly)

cat > "${OUTPUT_FILE}" <<EOF
{
  "location": "${LOCATION}",
  "date": "$(date +%Y-%m-%d)",
  "temperature_high": 32,
  "temperature_low": 21,
  "conditions": "Partly cloudy",
  "precipitation_chance": 10,
  "wind_speed": 15,
  "wind_direction": "NW"
}
EOF

# ── Output Validation ─────────────────────────────────────────────────────────
[ -s "${OUTPUT_FILE}" ] || { echo "ERROR: Output file is empty"; exit 1; }

echo "Weather data written to ${OUTPUT_FILE}"
