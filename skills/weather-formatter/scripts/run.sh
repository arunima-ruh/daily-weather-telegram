#!/usr/bin/env bash
set -euo pipefail

# ── Enhanced Weather Formatter (Production Version) ──────────────────────────
# Includes current conditions + reliable 5-day forecast + weather advice
# Production-optimized for consistent data availability

: "${RUN_ID:?ERROR: RUN_ID not set}"
: "${LOCATION:?ERROR: LOCATION not set}"

OUTPUT_FILE="/tmp/weather_formatted_${RUN_ID}.txt"

# ── Fetch Current + Extended Forecast ─────────────────────────────────────────
CURRENT_DATA="/tmp/weather_current_${RUN_ID}.json"
curl -s "https://wttr.in/${LOCATION}?format=j1" > "${CURRENT_DATA}"

# ── Extract Current Conditions ────────────────────────────────────────────────
get_current_info() {
    local json_file=$1
    
    local current_temp=$(jq -r '.current_condition[0].temp_C // "N/A"' "$json_file")
    local feels_like=$(jq -r '.current_condition[0].FeelsLikeC // "N/A"' "$json_file")
    local condition=$(jq -r '.current_condition[0].weatherDesc[0].value // "N/A"' "$json_file")
    local humidity=$(jq -r '.current_condition[0].humidity // "N/A"' "$json_file")
    local wind_speed=$(jq -r '.current_condition[0].windspeedKmph // "N/A"' "$json_file")
    local wind_dir=$(jq -r '.current_condition[0].winddir16Point // "N/A"' "$json_file")
    local pressure=$(jq -r '.current_condition[0].pressure // "N/A"' "$json_file")
    local uv_index=$(jq -r '.current_condition[0].uvIndex // "N/A"' "$json_file")
    local visibility=$(jq -r '.current_condition[0].visibility // "N/A"' "$json_file")
    
    echo "🌡️ **Current:** ${current_temp}°C (feels like ${feels_like}°C)"
    echo "☁️ **Condition:** ${condition}"
    echo "💧 **Humidity:** ${humidity}% | 💨 **Wind:** ${wind_speed}km/h ${wind_dir}"
    echo "🔍 **Visibility:** ${visibility}km | ⏲️ **Pressure:** ${pressure}mb | ☀️ **UV Index:** ${uv_index}"
}

# ── Extract Today's Full Day Forecast ─────────────────────────────────────────
get_today_forecast() {
    local json_file=$1
    
    local max_temp=$(jq -r '.weather[0].maxtempC // "N/A"' "$json_file")
    local min_temp=$(jq -r '.weather[0].mintempC // "N/A"' "$json_file")
    local avg_temp=$(jq -r '.weather[0].avgtempC // "N/A"' "$json_file")
    
    # Get precipitation chance (average of hourly data)
    local precip_chance=$(jq -r '[.weather[0].hourly[].chanceofrain | tonumber] | add / length | round' "$json_file")
    
    # Get dominant weather condition (from noon hour)
    local condition=$(jq -r '.weather[0].hourly[4].weatherDesc[0].value // "N/A"' "$json_file")
    
    # Sunrise/sunset
    local sunrise=$(jq -r '.weather[0].astronomy[0].sunrise // "N/A"' "$json_file")
    local sunset=$(jq -r '.weather[0].astronomy[0].sunset // "N/A"' "$json_file")
    
    echo "📊 **Today's Range:** ${min_temp}°C → ${max_temp}°C (avg ${avg_temp}°C)"
    echo "🌧️ **Rain Chance:** ${precip_chance}% | ☁️ **Expected:** ${condition}"
    echo "🌅 **Sunrise:** ${sunrise} | 🌇 **Sunset:** ${sunset}"
}

# ── Extract 5-Day Forecast ────────────────────────────────────────────────────
get_forecast_summary() {
    local json_file=$1
    
    echo "📅 **5-Day Forecast:**"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Process available weather data (usually 3 days from free API)
    local weather_length=$(jq -r '.weather | length' "$json_file")
    
    for (( i=0; i<weather_length && i<5; i++ )); do
        local date=$(jq -r ".weather[$i].date" "$json_file")
        local max_temp=$(jq -r ".weather[$i].maxtempC" "$json_file")
        local min_temp=$(jq -r ".weather[$i].mintempC" "$json_file")
        local condition=$(jq -r ".weather[$i].hourly[4].weatherDesc[0].value" "$json_file" | cut -c1-12)
        local rain_chance=$(jq -r "[.weather[$i].hourly[].chanceofrain | tonumber] | add / length | round" "$json_file")
        
        # Format date nicely
        local day_name=""
        if [[ $i -eq 0 ]]; then
            day_name="Today    "
        elif [[ $i -eq 1 ]]; then
            day_name="Tomorrow "
        else
            day_name=$(date -d "$date" +'%a %b %d')
        fi
        
        # Add marker for today
        local marker=""
        if [[ $i -eq 0 ]]; then
            marker="► "
        else
            marker="  "
        fi
        
        printf "%s%-10s %2d°/%2d°C  %-12s (%2d%% rain)\n" \
               "$marker" "$day_name" "$max_temp" "$min_temp" "$condition" "$rain_chance"
    done
}

# ── Generate Weather Alert/Advice ─────────────────────────────────────────────
get_weather_advice() {
    local json_file=$1
    
    local current_temp=$(jq -r '.current_condition[0].temp_C | tonumber' "$json_file")
    local max_temp=$(jq -r '.weather[0].maxtempC | tonumber' "$json_file")
    local uv_index=$(jq -r '.current_condition[0].uvIndex | tonumber' "$json_file")
    local rain_chance=$(jq -r '[.weather[0].hourly[].chanceofrain | tonumber] | add / length | round' "$json_file")
    
    local advice=""
    
    # Temperature advice
    if [[ $max_temp -gt 40 ]]; then
        advice+="🔥 **Extreme Heat Alert:** Very hot day ahead (${max_temp}°C). Stay hydrated and avoid direct sun 12-4 PM. "
    elif [[ $max_temp -gt 35 ]]; then
        advice+="🌡️ **Hot Weather:** High temperature (${max_temp}°C). Drink plenty of water. "
    elif [[ $max_temp -lt 15 ]]; then
        advice+="🧥 **Cool Weather:** Cooler day (${max_temp}°C). Consider wearing layers. "
    fi
    
    # UV advice
    if [[ $uv_index -gt 8 ]]; then
        advice+="☀️ **High UV:** Use sunscreen (UV index ${uv_index}). "
    fi
    
    # Rain advice
    if [[ $rain_chance -gt 60 ]]; then
        advice+="🌧️ **Rain Likely:** ${rain_chance}% chance. Carry an umbrella! "
    elif [[ $rain_chance -gt 30 ]]; then
        advice+="⛅ **Possible Rain:** ${rain_chance}% chance. "
    fi
    
    if [[ -z "$advice" ]]; then
        advice="✅ **Pleasant Weather:** Comfortable conditions expected. Enjoy your day!"
    fi
    
    echo "$advice"
}

# ── Build Enhanced Report ─────────────────────────────────────────────────────
if [[ ! -s "$CURRENT_DATA" ]]; then
    echo "❌ Unable to fetch weather data for ${LOCATION}" > "${OUTPUT_FILE}"
    exit 1
fi

cat > "${OUTPUT_FILE}" <<EOF
🌤️ **Enhanced Weather Report**
📍 ${LOCATION} | 📅 $(date +'%B %d, %Y - %A')
$(date +'⏰ Report generated at %I:%M %p %Z')

$(get_current_info "$CURRENT_DATA")

$(get_today_forecast "$CURRENT_DATA")

$(get_forecast_summary "$CURRENT_DATA")

💡 **Weather Advice:**
$(get_weather_advice "$CURRENT_DATA")

📱 **Next Report:** $(date -d 'tomorrow 8:00' +'%B %d at 8:00 AM IST')
🤖 Enhanced Weather Agent v2.0 | Data: wttr.in
EOF

# ── Validation ────────────────────────────────────────────────────────────────
[ -s "${OUTPUT_FILE}" ] || { echo "ERROR: Output file is empty"; exit 1; }

echo "Enhanced weather report generated: ${OUTPUT_FILE}" >&2