---
name: bydfi-futures-trader
description: Use when user mentions BYDFi and wants to trade futures contracts on production (real money) - placing orders, checking positions, querying prices, managing leverage, transferring funds, setting TP/SL. Requires "bydfi" keyword or when only one exchange skill is installed. Triggers on: bydfi price, bydfi balance, bydfi buy/sell, bydfi position, bydfi futures.
---

# BYDFi Futures Trader

Crypto futures contract trading on BYDFi **production** exchange (api.bydfi.com) via CLI tool.

> **WARNING: This skill uses REAL funds. All trades are on the live BYDFi exchange.**

## Setup

### Step 1: Install
```bash
pip3 install requests
```

### Step 2: Configure API Keys
```bash
python3 ~/.claude/skills/bydfi-futures-trader/bydfi_futures.py setup <your-api-key> <your-secret-key> [wallet]
```

Config is saved to `~/.bydfi/futures_config.json` (permissions 600).

**Configuration priority:** environment variables > config file.

### Where to get API Keys
1. Login to [BYDFi](https://www.bydfi.com)
2. Go to **Account → API Management → Create API Key**
3. Enable **Transaction** permission for trading operations

### Step 3: Verify
```bash
python3 ~/.claude/skills/bydfi-futures-trader/bydfi_futures.py price BTC-USDT
python3 ~/.claude/skills/bydfi-futures-trader/bydfi_futures.py balance
```

### Config File (`~/.bydfi/futures_config.json`)
```json
{
  "api_key": "your-api-key",
  "secret-key": "your-secret-key",
  "wallet": "W001"
}
```

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| api_key | Yes | - | BYDFi API Key |
| secret_key | Yes | - | BYDFi Secret Key |
| wallet | No | `W001` | Default contract wallet ID |

Environment variables override config file:
```bash
export BYDFI_API_KEY="..."
export BYDFI_SECRET_KEY="..."
export BYDFI_WALLET="W001"
```

## How to Use

```bash
python3 ~/.claude/skills/bydfi-futures-trader/bydfi_futures.py <command> [args]
```

## Quick Reference

| Action | Command |
|--------|---------|
| Check price | `price BTC-USDT` |
| Order book | `depth BTC-USDT 10` |
| 24h stats | `ticker BTC-USDT` |
| K-lines | `klines BTC-USDT 1m 20` |
| Funding rate | `funding BTC-USDT` |
| Trading pairs | `exchange_info` |
| Contract balance | `balance` |
| Spot balance | `assets spot USDT` |
| Transfer funds | `transfer SPOT SWAP USDT 100` |
| Current positions | `positions` |
| **Market buy** | `buy BTC-USDT 10` |
| **Limit buy** | `buy BTC-USDT 10 65000` |
| **Market sell** | `sell BTC-USDT 10` |
| **Close position** | `close BTC-USDT SELL` |
| **Take-profit** | `tp BTC-USDT SELL 90000 [qty]` |
| **Stop-loss** | `sl BTC-USDT SELL 60000 [qty]` |
| Query TP/SL | `plan_orders BTC-USDT` |
| Cancel orders | `cancel BTC-USDT [orderId]` |
| Open orders | `orders BTC-USDT` |
| Order history | `history BTC-USDT 10` |
| Get/set leverage | `leverage BTC-USDT` / `leverage BTC-USDT 10` |
| Margin type | `margin_type BTC-USDT CROSS` |
| Position mode | `position_mode HEDGE` |

## Critical Rules

### Quantity = Contracts, NOT Coins
`quantity` is **contract count** (integer). Each symbol has a `contractFactor`:
- BTC-USDT: 1 contract = 0.001 BTC → buy 0.1 BTC = `buy BTC-USDT 100`
- ETH-USDT: 1 contract = 0.01 ETH → buy 1 ETH = `buy ETH-USDT 100`

Use `exchange_info <symbol>` to check contractFactor.

### Take-Profit / Stop-Loss
- `tp <symbol> <side> <stopPrice> [qty]` — TAKE_PROFIT_MARKET, triggers market close at stopPrice
- `sl <symbol> <side> <stopPrice> [qty]` — STOP_MARKET, triggers market close at stopPrice
- `side` = direction to close: long position → `SELL`, short position → `BUY`
- Omit `qty` to auto-detect from current position
- **Always verify position exists before setting TP/SL**, or they become dangling orders that may open a new position
- Cancel dangling orders: `cancel <symbol> <orderId>`

### Closing Positions
To close, use the **opposite side**: close a BUY position with `close SYMBOL SELL`.

### Rate Limiting
- `place_order`: 1 req/sec max. Exceeding triggers **15-30 min ban**.
- On 510 error, script auto-falls back to `batch_place_order`.

## Safety

- **Always confirm with user before executing trades** — this is real money
- Show price and balance before placing orders
- Never auto-trade without explicit user instruction
- After buying, verify position with `positions` before setting TP/SL
