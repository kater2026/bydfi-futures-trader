# BYDFi Futures Trader - Claude Code Skill

A Claude Code skill for trading crypto futures contracts on **BYDFi production exchange** (api.bydfi.com). Configure your API key once, then trade with real funds by talking to Claude.

> **WARNING: This skill connects to the live BYDFi exchange and uses REAL funds. Always confirm trades before executing.**

## Quick Install

Run this one-liner in your terminal:

```bash
bash <(curl -s https://raw.githubusercontent.com/kater2026/bydfi-futures-trader/main/install.sh)
```

The installer will:
1. Download skill files to `~/.claude/skills/bydfi-futures-trader/`
2. Install the `requests` dependency
3. Prompt for your BYDFi API key and secret

## Manual Install

```bash
# 1. Copy files to skill directory
mkdir -p ~/.claude/skills/bydfi-futures-trader
cp SKILL.md bydfi_futures.py ~/.claude/skills/bydfi-futures-trader/

# 2. Install dependency
pip3 install requests

# 3. Configure API keys
python3 ~/.claude/skills/bydfi-futures-trader/bydfi_futures.py setup <your-api-key> <your-secret-key>
```

## Get API Keys

1. Login to [BYDFi](https://www.bydfi.com)
2. Go to **Account > API Management > Create API Key**
3. Enable **Transaction** permission

## Verify Setup

Open Claude Code and say:

```
"BYDFi BTC price"
"Check my BYDFi balance"
```

If this is the only exchange skill installed, you can also say:

```
"BTC price"
"Check my balance"
```

Claude will automatically use this skill to fetch live data from BYDFi.

## Usage

Just talk to Claude:

```
"Buy 0.1 BTC futures contract"
"Show my positions"
"What is the BTC price"
"Set ETH stop-loss at 10%"
"Close my BTC long position"
```

Or use CLI directly:

```bash
S=~/.claude/skills/bydfi-futures-trader/bydfi_futures.py

python3 $S price BTC-USDT          # Check price
python3 $S balance                  # Check balance
python3 $S positions                # View positions
python3 $S buy BTC-USDT 100        # Buy 100 contracts (= 0.1 BTC, market)
python3 $S buy BTC-USDT 100 65000  # Buy 100 contracts (limit @ 65000)
python3 $S sell BTC-USDT 100       # Sell 100 contracts
python3 $S close BTC-USDT SELL     # Close BUY position
python3 $S tp BTC-USDT SELL 90000  # Set take-profit @ 90000
python3 $S sl BTC-USDT SELL 60000  # Set stop-loss @ 60000
python3 $S plan_orders BTC-USDT    # View TP/SL orders
python3 $S cancel BTC-USDT         # Cancel all orders
python3 $S leverage BTC-USDT 10    # Set leverage
python3 $S margin_type BTC-USDT ISOLATED  # Set isolated margin
python3 $S help                    # All commands
```

## Configuration

Config saved at `~/.bydfi/futures_config.json` (permissions 600):

```json
{
  "api_key": "your-api-key",
  "secret_key": "your-secret-key",
  "wallet": "W001"
}
```

Environment variables override config file:

```bash
export BYDFI_API_KEY="..."
export BYDFI_SECRET_KEY="..."
export BYDFI_WALLET="W001"
```

## Important Notes

- **Production only** — connects to `api.bydfi.com` with real funds, no testnet
- **Quantity = contracts, not coins.** BTC: 1 contract = 0.001 BTC. Buy 0.1 BTC = 100 contracts.
- **Rate limit:** max 1 order/sec. Exceeding triggers 15-30 min ban.
- **Always verify position exists** before setting TP/SL, or they may open a new position instead of closing.

## Commands Reference

| Category | Command | Description |
|----------|---------|-------------|
| Market | `price <symbol>` | Latest price |
| Market | `depth <symbol> [limit]` | Order book |
| Market | `ticker [symbol]` | 24h stats |
| Market | `klines <symbol> <interval> [limit]` | K-lines |
| Market | `funding <symbol>` | Funding rate |
| Market | `exchange_info [symbol]` | Contract specs |
| Account | `balance` | Contract wallet balance |
| Account | `assets spot\|fund <asset>` | Spot/fund balance |
| Account | `transfer <from> <to> <asset> <amount>` | Transfer funds |
| Account | `positions [symbol]` | Current positions |
| Trading | `buy <symbol> <qty> [price]` | Buy (market/limit) |
| Trading | `sell <symbol> <qty> [price]` | Sell (market/limit) |
| Trading | `close <symbol> <BUY\|SELL> [qty]` | Close position |
| Trading | `tp <symbol> <side> <price> [qty]` | Take-profit |
| Trading | `sl <symbol> <side> <price> [qty]` | Stop-loss |
| Trading | `plan_orders <symbol>` | View TP/SL orders |
| Trading | `cancel <symbol> [orderId]` | Cancel orders |
| Trading | `orders <symbol>` | Open orders |
| Trading | `history [symbol] [limit]` | Order history |
| Settings | `leverage <symbol> [value]` | Get/set leverage |
| Settings | `margin_type <symbol> CROSS\|ISOLATED` | Margin mode |
| Settings | `position_mode HEDGE\|ONEWAY` | Position mode |

## Files

```
bydfi-futures-trader/
├── SKILL.md              # Claude Code skill definition
├── bydfi_futures.py     # Trading CLI
└── README.md             # This file
```

## License

MIT
