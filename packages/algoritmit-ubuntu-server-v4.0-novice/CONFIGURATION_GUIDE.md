# ⚙️ ALGORITMIT Configuration Guide for Novice Traders

**Complete configuration guide for setting up ALGORITMIT v4.0 on Ubuntu Server**

## 📋 Configuration Overview

This guide will help you configure ALGORITMIT for optimal performance and safety. The configuration is stored in the `.env` file and controls all aspects of the trading bot.

## 🔧 Basic Configuration Setup

### Step 1: Access Configuration File

```bash
# For root installation
sudo nano /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/.env

# For user installation
nano ~/algoritmit/algoritmit-ubuntu-server-v4.0-novice/.env
```

### Step 2: Essential Settings

Here's a complete `.env` file template with explanations:

```env
# =============================================================================
# ALGORITMIT Ubuntu Server Configuration v4.0
# =============================================================================

# 🔑 WALLET CONFIGURATION (REQUIRED)
# =============================================================================
# Your Worldcoin wallet private key (NEVER SHARE THIS!)
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# Add additional wallets if needed
# PRIVATE_KEY_2=your_second_private_key_here
# WALLET_NAME_2=Secondary Wallet

# 🌐 RPC CONFIGURATION
# =============================================================================
# Worldchain RPC endpoint (use Alchemy for better performance)
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key_here

# Alternative RPC endpoints (if Alchemy is unavailable)
# WORLDCHAIN_RPC_URL=https://rpc.worldcoin.org
# WORLDCHAIN_RPC_URL=https://worldchain.drpc.org

# 🤖 ALGORITMIT MACHINE LEARNING SETTINGS
# =============================================================================
# AI confidence threshold (50-95%, higher = fewer but better trades)
ML_CONFIDENCE_THRESHOLD=75

# Maximum position size per trade (in WLD)
ML_MAX_POSITION_SIZE=0.01

# Learning mode (true = bot learns without trading, false = live trading)
ML_LEARNING_MODE=true

# Auto trading (true = bot trades automatically, false = manual only)
ML_AUTO_TRADING=false

# Paper trading mode (true = simulated trades, false = real trades)
PAPER_TRADING=true

# 📱 TELEGRAM NOTIFICATIONS (OPTIONAL)
# =============================================================================
# Telegram bot token (get from @BotFather)
TELEGRAM_BOT_TOKEN=your_bot_token_here

# Your Telegram chat ID
TELEGRAM_CHAT_ID=your_chat_id_here

# Notification settings
TELEGRAM_TRADE_NOTIFICATIONS=true
TELEGRAM_ERROR_NOTIFICATIONS=true
TELEGRAM_DAILY_SUMMARY=true

# 📊 LOGGING CONFIGURATION
# =============================================================================
# Log level (debug, info, warn, error)
LOG_LEVEL=info

# Save logs to file
LOG_TO_FILE=true
LOG_FILE_PATH=./logs/bot.log

# Console logging
LOG_TO_CONSOLE=true

# 🚀 PERFORMANCE SETTINGS
# =============================================================================
# Price check interval in seconds (1-10)
PRICE_CHECK_INTERVAL=3

# Maximum concurrent trades
MAX_CONCURRENT_TRADES=3

# Gas limit buffer (1.1-2.0, higher = more gas allowance)
GAS_LIMIT_BUFFER=1.2

# Network timeout in seconds
NETWORK_TIMEOUT=30

# 🛡️ SAFETY SETTINGS
# =============================================================================
# Emergency stop (true = stops all trading immediately)
EMERGENCY_STOP=false

# Maximum daily loss percentage (0.1-10.0)
MAX_DAILY_LOSS=0.5

# Stop loss percentage per trade (1-50)
STOP_LOSS_PERCENTAGE=10

# Take profit percentage per trade (1-100)
TAKE_PROFIT_PERCENTAGE=20

# Maximum trades per day
MAX_TRADES_PER_DAY=10

# 💰 TRADING STRATEGY SETTINGS
# =============================================================================
# DIP buying levels (comma-separated percentages)
DIP_BUY_LEVELS=5,10,15,20

# DIP buy amounts (comma-separated WLD amounts)
DIP_BUY_AMOUNTS=0.01,0.02,0.03,0.04

# Profit taking levels (comma-separated percentages)
PROFIT_TAKE_LEVELS=10,20,30,50

# Profit take amounts (comma-separated percentages of position)
PROFIT_TAKE_AMOUNTS=25,25,25,25

# 🔄 ADVANCED SETTINGS
# =============================================================================
# Enable price triggers
ENABLE_PRICE_TRIGGERS=true

# Enable token discovery
ENABLE_TOKEN_DISCOVERY=true

# Enable gas estimation
ENABLE_GAS_ESTIMATION=true

# Enable strategy builder
ENABLE_STRATEGY_BUILDER=true

# Database settings
DB_PATH=./data/trading.db
DB_BACKUP_INTERVAL=24

# =============================================================================
# END OF CONFIGURATION
# =============================================================================
```

## 🎯 Novice Trader Recommended Settings

### Phase 1: Learning Mode (First 24-48 hours)

```env
# Start with these safe settings
ML_CONFIDENCE_THRESHOLD=80
ML_MAX_POSITION_SIZE=0.01
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false
PAPER_TRADING=true
MAX_DAILY_LOSS=0.1
STOP_LOSS_PERCENTAGE=5
MAX_TRADES_PER_DAY=5
```

### Phase 2: Paper Trading (Days 3-7)

```env
# Test with paper trading
ML_LEARNING_MODE=false
ML_AUTO_TRADING=true
PAPER_TRADING=true
ML_MAX_POSITION_SIZE=0.01
ML_CONFIDENCE_THRESHOLD=75
MAX_DAILY_LOSS=0.5
STOP_LOSS_PERCENTAGE=10
```

### Phase 3: Live Trading (Days 8+)

```env
# Live trading with safety measures
ML_LEARNING_MODE=false
ML_AUTO_TRADING=true
PAPER_TRADING=false
ML_MAX_POSITION_SIZE=0.05
ML_CONFIDENCE_THRESHOLD=70
MAX_DAILY_LOSS=1.0
STOP_LOSS_PERCENTAGE=15
```

## 🔑 Wallet Configuration

### Getting Your Private Key

**⚠️ SECURITY WARNING: Never share your private key with anyone!**

#### From MetaMask:
1. Open MetaMask extension
2. Click on your account icon
3. Go to "Account Details"
4. Click "Export Private Key"
5. Enter your password
6. Copy the private key

#### From World App:
1. Open World App
2. Go to Settings → Security
3. Tap "Export Private Key"
4. Enter your password
5. Copy the private key

#### From Other Wallets:
- Look for "Export Private Key" or "Show Private Key"
- Follow the wallet's security prompts
- Copy the private key

### Adding Multiple Wallets

```env
# Primary wallet
PRIVATE_KEY_1=your_primary_private_key
WALLET_NAME_1=Main Trading Wallet

# Secondary wallet (optional)
PRIVATE_KEY_2=your_secondary_private_key
WALLET_NAME_2=Backup Wallet

# Additional wallets
PRIVATE_KEY_3=your_third_private_key
WALLET_NAME_3=Test Wallet
```

## 🌐 RPC Configuration

### Alchemy Setup (Recommended)

1. **Create Alchemy Account:**
   - Visit https://alchemy.com
   - Sign up for free account
   - Create new app for Worldchain

2. **Get API Key:**
   - Copy your API key from Alchemy dashboard
   - Add to configuration

3. **Configure RPC:**
```env
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key_here
```

### Alternative RPC Providers

```env
# Public RPC (free, but slower)
WORLDCHAIN_RPC_URL=https://rpc.worldcoin.org

# DRPC (free tier available)
WORLDCHAIN_RPC_URL=https://worldchain.drpc.org

# Your own RPC node
WORLDCHAIN_RPC_URL=http://your-node-ip:8545
```

## 📱 Telegram Notifications Setup

### Step 1: Create Telegram Bot

1. Message `@BotFather` on Telegram
2. Send `/newbot` command
3. Follow instructions to create bot
4. Copy the bot token

### Step 2: Get Your Chat ID

1. Message your bot
2. Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
3. Find your `chat_id` in the response

### Step 3: Configure Notifications

```env
# Basic Telegram setup
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here

# Notification preferences
TELEGRAM_TRADE_NOTIFICATIONS=true
TELEGRAM_ERROR_NOTIFICATIONS=true
TELEGRAM_DAILY_SUMMARY=true
```

## 🛡️ Safety Configuration

### Risk Management Settings

```env
# Conservative settings for beginners
MAX_DAILY_LOSS=0.5          # Maximum 0.5% loss per day
STOP_LOSS_PERCENTAGE=10     # Stop loss at 10% loss
TAKE_PROFIT_PERCENTAGE=20   # Take profit at 20% gain
MAX_TRADES_PER_DAY=10       # Maximum 10 trades per day
EMERGENCY_STOP=false        # Set to true to stop all trading
```

### Position Sizing

```env
# Start with very small positions
ML_MAX_POSITION_SIZE=0.01   # 0.01 WLD per trade

# Gradually increase as you gain experience
# ML_MAX_POSITION_SIZE=0.05   # 0.05 WLD per trade
# ML_MAX_POSITION_SIZE=0.1    # 0.1 WLD per trade
```

## 📊 Performance Optimization

### System Performance

```env
# Optimize for performance
PRICE_CHECK_INTERVAL=3      # Check prices every 3 seconds
MAX_CONCURRENT_TRADES=3     # Maximum 3 trades at once
NETWORK_TIMEOUT=30          # 30 second timeout
GAS_LIMIT_BUFFER=1.2        # 20% gas buffer
```

### Logging Optimization

```env
# Reduce log verbosity for better performance
LOG_LEVEL=info              # info, warn, error only
LOG_TO_FILE=true            # Save logs to file
LOG_TO_CONSOLE=false        # Reduce console output
```

## 🔄 Advanced Configuration

### DIP Buying Strategy

```env
# Buy more at deeper dips
DIP_BUY_LEVELS=5,10,15,20   # Buy at 5%, 10%, 15%, 20% dips
DIP_BUY_AMOUNTS=0.01,0.02,0.03,0.04  # Increasing amounts
```

### Profit Taking Strategy

```env
# Take profits at multiple levels
PROFIT_TAKE_LEVELS=10,20,30,50       # Sell at 10%, 20%, 30%, 50% gains
PROFIT_TAKE_AMOUNTS=25,25,25,25      # Sell 25% at each level
```

### Price Triggers

```env
# Enable price-based trading
ENABLE_PRICE_TRIGGERS=true
PRICE_CHECK_INTERVAL=3
```

## 🔧 Configuration Validation

### Test Your Configuration

```bash
# Validate configuration
algoritmit validate-config

# Test RPC connection
algoritmit test-rpc

# Test wallet connection
algoritmit test-wallet

# Test Telegram notifications
algoritmit test-telegram
```

### Common Configuration Errors

1. **Invalid Private Key:**
   - Ensure private key starts with `0x`
   - Check for extra spaces or characters

2. **RPC Connection Failed:**
   - Verify internet connection
   - Check RPC URL format
   - Test with curl: `curl -X POST $WORLDCHAIN_RPC_URL`

3. **Telegram Notifications Not Working:**
   - Verify bot token format
   - Check chat ID is correct
   - Ensure bot is not blocked

## 📝 Configuration Examples

### Conservative Trader
```env
ML_CONFIDENCE_THRESHOLD=85
ML_MAX_POSITION_SIZE=0.01
ML_LEARNING_MODE=true
MAX_DAILY_LOSS=0.2
STOP_LOSS_PERCENTAGE=5
```

### Moderate Trader
```env
ML_CONFIDENCE_THRESHOLD=75
ML_MAX_POSITION_SIZE=0.05
ML_LEARNING_MODE=false
MAX_DAILY_LOSS=1.0
STOP_LOSS_PERCENTAGE=10
```

### Aggressive Trader
```env
ML_CONFIDENCE_THRESHOLD=65
ML_MAX_POSITION_SIZE=0.1
ML_LEARNING_MODE=false
MAX_DAILY_LOSS=2.0
STOP_LOSS_PERCENTAGE=15
```

## 🔄 Updating Configuration

### Hot Reload (Recommended)

```bash
# Edit configuration
algoritmit config

# Reload configuration without restart
algoritmit reload-config
```

### Restart Method

```bash
# Stop bot
algoritmit stop

# Edit configuration
algoritmit config

# Start bot
algoritmit start
```

## 📞 Getting Help

### Configuration Issues

- **Check logs:** `algoritmit logs`
- **Validate config:** `algoritmit validate-config`
- **Test connections:** `algoritmit test-all`

### Community Support

- **Telegram Group:** [ALGORITMIT Community](https://t.me/algoritmit_community)
- **Discord Server:** [ALGORITMIT Discord](https://discord.gg/algoritmit)
- **GitHub Issues:** [Report Issues](https://github.com/romerodevv/psgho/issues)

---

**Remember: Start with conservative settings and gradually adjust based on performance! 🚀**