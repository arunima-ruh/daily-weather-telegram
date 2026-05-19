#!/usr/bin/env bash
set -euo pipefail

echo "Checking environment for daily-weather-telegram..."

ERRORS=0

# Required
if [ -z "${TELEGRAM_BOT_TOKEN:-}" ]; then
  echo "❌ TELEGRAM_BOT_TOKEN not set"
  ERRORS=$((ERRORS + 1))
else
  echo "✅ TELEGRAM_BOT_TOKEN set"
fi

if [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
  echo "❌ TELEGRAM_CHAT_ID not set"
  ERRORS=$((ERRORS + 1))
else
  echo "✅ TELEGRAM_CHAT_ID set"
fi

# Optional
if [ -z "${LOCATION:-}" ]; then
  echo "⚠️  LOCATION not set (will default to Sasaram)"
else
  echo "✅ LOCATION set to: ${LOCATION}"
fi

if [ -z "${PG_CONNECTION_STRING:-}" ]; then
  echo "⚠️  PG_CONNECTION_STRING not set (database logging disabled)"
else
  echo "✅ PG_CONNECTION_STRING set"
fi

# Check binaries
for BIN in python3 jq; do
  if command -v $BIN &> /dev/null; then
    echo "✅ $BIN found"
  else
    echo "❌ $BIN not found"
    ERRORS=$((ERRORS + 1))
  fi
done

if [ $ERRORS -eq 0 ]; then
  echo ""
  echo "✅ Environment check passed!"
  exit 0
else
  echo ""
  echo "❌ Environment check failed with $ERRORS error(s)"
  exit 1
fi
