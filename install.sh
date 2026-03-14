#!/bin/bash
# BYDFi Futures Trader - One-line installer for Claude Code skill
# Usage: bash <(curl -s https://raw.githubusercontent.com/kater2026/bydfi-futures-trader/main/install.sh)

set -e

SKILL_DIR="$HOME/.claude/skills/bydfi-futures-trader"
REPO_BASE="https://raw.githubusercontent.com/kater2026/bydfi-futures-trader/main"

echo "========================================"
echo "  BYDFi Futures Trader - Installer"
echo "  WARNING: Connects to REAL funds"
echo "========================================"
echo

# 1. Create skill directory
mkdir -p "$SKILL_DIR"
echo "[1/4] Created $SKILL_DIR"

# 2. Download files
curl -sL "$REPO_BASE/SKILL.md" -o "$SKILL_DIR/SKILL.md"
curl -sL "$REPO_BASE/bydfi_futures.py" -o "$SKILL_DIR/bydfi_futures.py"
chmod +x "$SKILL_DIR/bydfi_futures.py"
echo "[2/4] Downloaded SKILL.md + bydfi_futures.py"

# 3. Install dependency
if python3 -c "import requests" 2>/dev/null; then
    echo "[3/4] requests already installed"
else
    pip3 install requests -q
    echo "[3/4] Installed requests"
fi

# 4. Setup API keys
echo "[4/4] Configure API keys"
echo
echo "  Get your API key from:"
echo "    https://www.bydfi.com (Account > API Management)"
echo
read -p "  API Key: " api_key
read -p "  Secret Key: " secret_key

if [ -n "$api_key" ] && [ -n "$secret_key" ]; then
    python3 "$SKILL_DIR/bydfi_futures.py" setup "$api_key" "$secret_key"
else
    echo
    echo "  Skipped. Run later:"
    echo "    python3 $SKILL_DIR/bydfi_futures.py setup <api_key> <secret_key>"
fi

echo
echo "========================================"
echo "  Installation complete!"
echo "========================================"
echo
echo "  Verify: python3 $SKILL_DIR/bydfi_futures.py price BTC-USDT"
echo
echo "  In Claude Code, just say:"
echo "    'Buy 0.1 BTC futures contract'"
echo "    'Check my positions'"
echo "    'Set ETH stop-loss at 10%'"
echo
