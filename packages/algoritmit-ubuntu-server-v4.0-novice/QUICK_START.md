# 🚀 ALGORITMIT Quick Start Guide for Novice Traders

**Get started with ALGORITMIT in 10 minutes - Complete beginner's guide**

## 📋 Prerequisites Checklist

Before you start, make sure you have:

- ✅ **Ubuntu Server** (20.04, 22.04, or 24.04)
- ✅ **Root access** or **sudo privileges**
- ✅ **Worldcoin Wallet** with some WLD tokens
- ✅ **Alchemy Account** (optional, for better performance)
- ✅ **Telegram Bot** (optional, for notifications)

## 🎯 Installation Options

### Option 1: One-Line Installation (Recommended)

**For Root Users:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-root.sh | sudo bash
```

**For Non-Root Users:**
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-novice.sh | bash
```

### Option 2: Manual Installation

```bash
# Download the installer
wget https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-root.sh
chmod +x install-algoritmit-ubuntu-root.sh
sudo ./install-algoritmit-ubuntu-root.sh
```

## ⚙️ Configuration Setup

### Step 1: Edit Configuration File

```bash
# For root installation
sudo nano /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/.env

# For user installation
nano ~/algoritmit/algoritmit-ubuntu-server-v4.0-novice/.env
```

### Step 2: Configure Your Settings

Edit the following key settings in your `.env` file:

```env
# 🔑 Wallet Configuration (REQUIRED)
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# 🌐 RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key

# 🤖 ALGORITMIT Settings (NOVICE RECOMMENDED)
ML_CONFIDENCE_THRESHOLD=75
ML_MAX_POSITION_SIZE=0.01
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false

# 📱 Telegram Notifications (Optional)
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id
```

### Step 3: Get Your Private Key

**⚠️ IMPORTANT: Never share your private key!**

1. **From MetaMask:**
   - Open MetaMask
   - Click Account → Export Private Key
   - Enter your password
   - Copy the private key

2. **From World App:**
   - Open World App
   - Go to Settings → Security
   - Export private key
   - Copy the private key

3. **From Other Wallets:**
   - Look for "Export Private Key" or "Show Private Key"
   - Copy the private key

## 🚀 Starting ALGORITMIT

### Method 1: Using Management Script (Recommended)

```bash
# Start the service
algoritmit start

# Check status
algoritmit status

# View logs
algoritmit logs
```

### Method 2: Manual Start

```bash
# Navigate to installation directory
cd /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice

# Start the bot
./start.sh
```

### Method 3: System Service

```bash
# Start system service
sudo systemctl start algoritmit

# Enable auto-start
sudo systemctl enable algoritmit

# Check status
sudo systemctl status algoritmit
```

## 🎯 First-Time Setup for Novice Traders

### Phase 1: Learning Mode (Days 1-2)

1. **Start with Learning Mode:**
   ```env
   ML_LEARNING_MODE=true
   ML_AUTO_TRADING=false
   ```

2. **Use Small Position Sizes:**
   ```env
   ML_MAX_POSITION_SIZE=0.01
   ```

3. **Monitor Performance:**
   - Check logs: `algoritmit logs`
   - Monitor for 24-48 hours
   - Let the AI learn market patterns

### Phase 2: Paper Trading (Days 3-7)

1. **Enable Paper Trading:**
   ```env
   ML_LEARNING_MODE=false
   ML_AUTO_TRADING=true
   PAPER_TRADING=true
   ```

2. **Test with Small Amounts:**
   ```env
   ML_MAX_POSITION_SIZE=0.01
   ```

3. **Monitor Results:**
   - Check trading performance
   - Review AI predictions
   - Adjust settings if needed

### Phase 3: Live Trading (Days 8+)

1. **Enable Live Trading:**
   ```env
   PAPER_TRADING=false
   ML_AUTO_TRADING=true
   ```

2. **Gradually Increase Position Size:**
   ```env
   ML_MAX_POSITION_SIZE=0.05
   ```

3. **Monitor Closely:**
   - Check performance daily
   - Review logs regularly
   - Adjust settings based on results

## 📊 Monitoring Your Bot

### Check Bot Status

```bash
# Service status
algoritmit status

# Real-time logs
algoritmit logs

# Performance metrics
algoritmit stats
```

### View Trading Performance

```bash
# Check recent trades
algoritmit trades

# View profit/loss
algoritmit pnl

# Check wallet balance
algoritmit balance
```

### Emergency Controls

```bash
# Stop trading immediately
algoritmit stop

# Emergency stop (stops all trading)
algoritmit emergency-stop

# Resume trading
algoritmit start
```

## 🔧 Common Issues & Solutions

### Issue 1: "Node.js not found"
```bash
# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Issue 2: "Permission denied"
```bash
# Fix permissions
sudo chown -R $USER:$USER ~/algoritmit
chmod +x ~/algoritmit/algoritmit-ubuntu-server-v4.0-novice/*.sh
```

### Issue 3: "Connection failed"
```bash
# Check internet connection
ping -c 3 google.com

# Test RPC connection
curl -X POST https://worldchain-mainnet.g.alchemy.com/public
```

### Issue 4: "Insufficient funds"
- Add more WLD tokens to your wallet
- Check gas fees are covered
- Verify wallet balance

## 📱 Telegram Notifications Setup

### Step 1: Create Telegram Bot

1. Message `@BotFather` on Telegram
2. Send `/newbot`
3. Follow instructions to create bot
4. Copy the bot token

### Step 2: Get Chat ID

1. Message your bot
2. Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
3. Find your `chat_id` in the response

### Step 3: Configure Notifications

```bash
# Edit configuration
algoritmit config

# Add Telegram settings
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here
```

## 🛡️ Safety Tips for Novice Traders

### 1. Start Small
- Begin with 0.01 WLD positions
- Never invest more than you can afford to lose
- Gradually increase position sizes

### 2. Use Learning Mode
- Always start with learning mode enabled
- Let the AI learn for at least 24 hours
- Monitor performance before live trading

### 3. Set Stop Losses
```env
STOP_LOSS_PERCENTAGE=10
MAX_DAILY_LOSS=0.5
```

### 4. Monitor Regularly
- Check bot status daily
- Review trading performance
- Monitor system resources

### 5. Keep Backups
```bash
# Backup configuration
cp .env .env.backup

# Backup wallet data
cp wallets.json wallets.json.backup
```

## 📞 Getting Help

### Documentation
- **Full Guide**: `README.md`
- **Configuration**: `CONFIGURATION_GUIDE.md`
- **Troubleshooting**: `TROUBLESHOOTING.md`

### Community Support
- **Telegram Group**: [ALGORITMIT Community](https://t.me/algoritmit_community)
- **Discord Server**: [ALGORITMIT Discord](https://discord.gg/algoritmit)
- **GitHub Issues**: [Report Issues](https://github.com/romerodevv/psgho/issues)

### Contact Support
- **Email**: support@algoritmit.com
- **Telegram**: @algoritmit_support

## 🎉 Congratulations!

You've successfully set up ALGORITMIT! Here's what to do next:

1. **Monitor Learning Mode** for 24-48 hours
2. **Review Performance** and adjust settings
3. **Start with Small Positions** when ready
4. **Join the Community** for support and tips
5. **Keep Learning** and improving your strategy

---

**Happy Trading! 🚀**

*Remember: Start small, learn continuously, and never invest more than you can afford to lose.*