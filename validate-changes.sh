#!/bin/bash
# validate-changes.sh - MANDATORY validation before any git commit
# Usage: ./validate-changes.sh ["optional commit message to check"]
#
# STRICT SECURITY RULES:
# - NO secrets in code, comments, commit messages, or documentation
# - NO hardcoded tokens, chat IDs, connection strings, or API keys
# - NO specific environment variable values revealed anywhere
# - ALL sensitive data MUST use generic examples or env var references

set -e

echo "🔍 Validating changes before commit..."

# Determine if we're in project root or workspace
WORKSPACE_DIR="/root/.openclaw/workspace"
if [[ -f "SOUL.md" && -d ".openclaw" ]]; then
    # We're in the workspace
    WORKSPACE_DIR="."
    echo "ℹ️ Running from workspace directory"
elif [[ -d "/root/.openclaw/workspace" ]]; then
    # We're in project root, workspace is elsewhere
    WORKSPACE_DIR="/root/.openclaw/workspace"
    echo "ℹ️ Running from project root, checking workspace at $WORKSPACE_DIR"
else
    echo "❌ Cannot find OpenClaw workspace"
    exit 1
fi

# Check 1: OpenClaw workspace structure
echo "✅ Checking OpenClaw workspace structure..."
required_files=("SOUL.md" "AGENTS.md" "TOOLS.md" "README.md")
for file in "${required_files[@]}"; do
    if [[ ! -f "${WORKSPACE_DIR}/$file" ]]; then
        echo "❌ Missing required file: $file"
        exit 1
    fi
done

if [[ ! -d "${WORKSPACE_DIR}/.openclaw" ]]; then
    echo "❌ Missing .openclaw directory"
    exit 1
fi

if [[ ! -e "${WORKSPACE_DIR}/skills" ]]; then
    echo "❌ Missing skills directory or symlink"
    exit 1
fi

# Check 2: Environment variables accessible
echo "✅ Checking environment variables..."
required_vars=("PROJECT_ROOT" "TELEGRAM_CHAT_ID" "LOCATION")
for var in "${required_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        echo "❌ Missing environment variable: $var"
        exit 1
    fi
done

# Check 3: Skills functional
echo "✅ Checking skills directory..."
if [[ ! -d "${WORKSPACE_DIR}/skills" ]]; then
    echo "❌ Missing skills directory"
    exit 1
fi

# Check for core weather skills
skill_dirs=("weather-fetcher" "weather-formatter" "telegram-delivery" "data-writer")
for skill in "${skill_dirs[@]}"; do
    if [[ ! -d "${WORKSPACE_DIR}/skills/$skill" ]]; then
        echo "⚠️ Warning: Missing skill directory: $skill (this may be expected)"
    fi
done

# Check 4: No secrets in staged files or commit messages
echo "✅ Checking for secrets in staged files..."
if git diff --staged | grep -iE "token|key|secret|password|openclaw\.json|chat_id.*[0-9]|bot_token.*[a-zA-Z0-9]|pg_connection.*@|telegram_.*[0-9]|location.*delhi" > /dev/null; then
    echo "❌ STOP - Secrets found in staged files!"
    echo "Remove these before committing:"
    git diff --staged | grep -iE "token|key|secret|password|openclaw\.json|chat_id|bot_token|pg_connection|telegram_|location.*delhi"
    exit 1
fi

# Check commit message for secrets (if provided)
if [[ -n "$1" ]]; then
    if echo "$1" | grep -iE "token.*[a-zA-Z0-9]|key.*[a-zA-Z0-9]|secret.*[a-zA-Z0-9]|password.*[a-zA-Z0-9]|chat_id.*[0-9]|bot_token.*[a-zA-Z0-9]|pg_connection.*@|telegram.*[0-9]{6,}|delhi" > /dev/null; then
        echo "❌ STOP - Secrets found in commit message!"
        echo "Commit message contains sensitive information. Rewrite without revealing:"
        echo "- API tokens or bot tokens"
        echo "- Chat IDs or channel IDs"
        echo "- Database connection strings"
        echo "- Specific location details"
        echo "- Any environment variable values"
        exit 1
    fi
fi

echo "✅ Checking description and documentation for secrets..."
for file in README.md AGENTS.md SOUL.md TOOLS.md; do
    if [[ -f "${WORKSPACE_DIR}/$file" ]]; then
        if grep -iE "bot[0-9]+:[a-zA-Z0-9_-]+|postgresql://.*@|chat_id.*[0-9]{8,}|telegram.*[0-9]{8,}" "${WORKSPACE_DIR}/$file" > /dev/null; then
            echo "❌ STOP - Hardcoded secrets found in $file!"
            echo "Remove specific values and use generic examples or env var references"
            exit 1
        fi
    fi
done

# Check 5: Natural conversation style rules in SOUL.md
echo "✅ Checking communication style rules..."
if ! grep -q "Communication Style" "${WORKSPACE_DIR}/SOUL.md"; then
    echo "❌ Missing communication style section in SOUL.md"
    exit 1
fi

# Check 6: Consistency between SOUL.md and AGENTS.md
echo "✅ Checking consistency between configuration files..."
if grep -q "file paths\|script locations\|technical details" "${WORKSPACE_DIR}/SOUL.md"; then
    if ! grep -q "NEVER mention file paths" "${WORKSPACE_DIR}/AGENTS.md"; then
        echo "❌ Inconsistency: SOUL.md mentions technical details but AGENTS.md doesn't have matching rules"
        exit 1
    fi
fi

# Check 7: Git branch safety
echo "✅ Checking git branch..."
current_branch=$(git branch --show-current)
if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    echo "❌ Cannot commit to main/master branch!"
    echo "Create a feature branch: git checkout -b agent/<description>"
    exit 1
fi

echo "🎉 All validation checks passed! Safe to commit."
echo "Current branch: $current_branch"
echo "Staged files:"
git diff --staged --name-only