#!/usr/bin/env bash
set -euo pipefail

echo "Testing daily-weather-telegram workflow..."

# Load environment
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
else
  echo "❌ .env file not found. Copy .env.example to .env first."
  exit 1
fi

# Set test environment
export RUN_ID="test-$(date +%s)"
export PROJECT_ROOT="$(pwd)"

echo "Using RUN_ID: ${RUN_ID}"

# Check environment
./check-environment.sh || exit 1

echo ""
echo "Running workflow steps..."

# Step 1: Provision database
echo "Step 1: Provision database (if PG configured)..."
if [ -n "${PG_CONNECTION_STRING:-}" ]; then
  python3 scripts/data_writer.py provision || echo "⚠️  Database provision skipped or failed"
else
  echo "⚠️  Skipping (PG_CONNECTION_STRING not set)"
fi

# Step 2: Fetch weather
echo ""
echo "Step 2: Fetch weather..."
bash workspace/skills/weather-fetcher/scripts/run.sh || { echo "❌ Weather fetch failed"; exit 1; }
echo "✅ Weather data fetched"

# Step 3: Format message
echo ""
echo "Step 3: Format message..."
bash workspace/skills/weather-formatter/scripts/run.sh || { echo "❌ Formatting failed"; exit 1; }
echo "✅ Message formatted"

# Step 4: Deliver to Telegram
echo ""
echo "Step 4: Deliver to Telegram..."
bash workspace/skills/telegram-delivery/scripts/run.sh || { echo "❌ Delivery failed"; exit 1; }
echo "✅ Delivery complete"

# Show output
echo ""
echo "── Formatted Message ──"
cat "/tmp/weather_formatted_${RUN_ID}.txt"

echo ""
echo "✅ Workflow test completed successfully!"
