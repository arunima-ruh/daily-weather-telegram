#!/usr/bin/env bash
set -euo pipefail

echo "Installing dependencies for daily-weather-telegram..."

# Python dependencies
if command -v pip3 &> /dev/null; then
  echo "Installing Python packages..."
  pip3 install -r requirements.txt
  echo "✅ Python dependencies installed"
else
  echo "❌ pip3 not found. Install Python 3 and pip first."
  exit 1
fi

# Check jq
if ! command -v jq &> /dev/null; then
  echo "⚠️  jq not found. Install it with:"
  echo "  - macOS: brew install jq"
  echo "  - Debian/Ubuntu: sudo apt-get install jq"
  echo "  - RHEL/CentOS: sudo yum install jq"
  exit 1
fi

echo "✅ All dependencies installed!"
