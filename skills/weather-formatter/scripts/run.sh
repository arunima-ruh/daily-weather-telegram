#!/usr/bin/env bash
set -euo pipefail

# ── Env Vars ──────────────────────────────────────────────────────────────────
: "${RUN_ID:?ERROR: RUN_ID not set}"

# ── File Paths ────────────────────────────────────────────────────────────────
INPUT_FILE="/tmp/weather_${RUN_ID}.json"
OUTPUT_FILE="/tmp/weather_formatted_${RUN_ID}.txt"

# ── Input Validation ──────────────────────────────────────────────────────────
[ -s "${INPUT_FILE}" ] || { echo "ERROR: Input file missing or empty"; exit 1; }

# ── Extract Data ──────────────────────────────────────────────────────────────
LOCATION=$(jq -r '.location' "${INPUT_FILE}")
DATE=$(jq -r '.date' "${INPUT_FILE}")
TEMP_HIGH=$(jq -r '.temperature_high' "${INPUT_FILE}")
TEMP_LOW=$(jq -r '.temperature_low' "${INPUT_FILE}")
CONDITIONS=$(jq -r '.conditions' "${INPUT_FILE}")
PRECIP=$(jq -r '.precipitation_chance' "${INPUT_FILE}")
WIND=$(jq -r '.wind_speed' "${INPUT_FILE}")

# ── Format Message ────────────────────────────────────────────────────────────
cat > "${OUTPUT_FILE}" <<EOF
🌤️ **Weather Forecast for ${LOCATION}**
📅 ${DATE}

🌡️ **Temperature**
High: ${TEMP_HIGH}°C | Low: ${TEMP_LOW}°C

☁️ **Conditions**
${CONDITIONS}

💧 **Precipitation**
${PRECIP}% chance of rain

💨 **Wind**
${WIND} km/h

Have a great day! 🌞
EOF

# ── Output Validation ─────────────────────────────────────────────────────────
[ -s "${OUTPUT_FILE}" ] || { echo "ERROR: Output file is empty"; exit 1; }

echo "Formatted weather message written to ${OUTPUT_FILE}"
