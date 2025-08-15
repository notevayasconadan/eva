# 🚀 Worldchain Trader Novice Package

**Complete AI-powered trading bot for Worldchain - Perfect for Ubuntu beginners!**

## 🎯 Quick Start

### One-Command Installation (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/main/worldchain-trader-novice-package/install-ubuntu-one-line.sh | bash
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/notevayasconadan/eva.git
cd eva/worldchain-trader-novice-package

# Run the installer
./install-ubuntu.sh
```

## ✨ Features

### 🤖 AI-Powered Trading
- **Machine Learning Models**: Predicts price movements using historical data
- **Pattern Recognition**: Identifies bullish, bearish, and neutral patterns
- **Automated Learning**: Continuously improves from market data
- **Risk-Adjusted Trading**: Position sizing based on confidence and volatility

### 🛡️ Safety Features
- **Learning Mode**: AI learns without trading for 24+ hours first
- **Position Limits**: Configurable maximum position sizes
- **Confidence Thresholds**: Only trade with high-confidence predictions
- **Stop Loss Protection**: Automatic loss prevention
- **Manual Override**: Disable auto-trading anytime

### 📊 Advanced Analytics
- **Real-time Performance Tracking**: Monitor win rate and profit/loss
- **ML Accuracy Monitoring**: Track prediction performance
- **Portfolio Management**: Manage multiple wallets and tokens
- **Telegram Notifications**: Get alerts on your phone

## 🚀 Getting Started

### 1. Initial Setup
```bash
cd ~/worldchain-trader
./setup-novice.sh
```

### 2. Configure Your Wallet
Edit the `.env` file:
```bash
nano .env
```

**Required Settings:**
- `PRIVATE_KEY_1`: Your wallet private key
- `ALCHEMY_API_KEY`: Your Alchemy API key

**Optional Settings:**
- `TELEGRAM_BOT_TOKEN`: For mobile notifications
- `MAX_POSITION_SIZE`: Maximum trade size (default: 0.1 WLD)

### 3. Start Trading
```bash
# Start manually
./start-trader.sh

# Or start as a service
./start-pm2.sh

# Or use systemd
sudo systemctl start worldchain-trader
sudo systemctl enable worldchain-trader
```

## 📋 Safety Protocol

### Phase 1: Learning (Days 1-2)
- Enable Learning Mode only
- Let AI collect market data for 24+ hours
- Monitor ML accuracy until it reaches 60%+

### Phase 2: Testing (Days 3-7)
- Start with 0.01 WLD positions
- Enable auto-trading with high confidence threshold (80%+)
- Monitor closely for first week

### Phase 3: Scaling (Days 8+)
- Gradually increase position sizes
- Adjust confidence thresholds based on performance
- Continue monitoring daily

## ⚙️ Configuration

### Environment Variables (.env)
```env
# Wallet Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key

# Trading Configuration
MAX_POSITION_SIZE=0.1          # Maximum WLD per trade
SLIPPAGE_TOLERANCE=5           # Slippage tolerance in %
GAS_LIMIT=300000               # Gas limit for transactions

# AI Trading Settings
ML_CONFIDENCE_THRESHOLD=75     # 50-95% (higher = fewer but better trades)
ML_LEARNING_MODE=true          # Start with learning only
ML_AUTO_TRADING=false          # Enable after learning period

# Safety Settings
ENABLE_STOP_LOSS=true          # Enable automatic stop loss
STOP_LOSS_PERCENTAGE=10        # Stop loss percentage
MAX_DAILY_TRADES=10            # Maximum trades per day
```

## 🎮 Usage

### Main Menu Options
1. **🏠 Wallet Management**: Create, import, and manage wallets
2. **🔍 Token Discovery**: Find tokens in your wallets automatically
3. **📈 Trading Operations**: Execute manual trades
4. **🎯 Strategy Management**: Traditional DIP/profit strategies
5. **🏗️ Strategy Builder**: Custom trading strategies
6. **🎯 Price Triggers**: Automated buy/sell based on price conditions
7. **🤖 ALGORITMIT**: AI-powered machine learning trading ⭐

### Console Commands
```bash
buy YIELD 0.10 d15 p15    # Buy YIELD with 0.10 WLD, 15% DIP, 15% profit
buy YIELD 0.10            # Immediate buy with 0.10 WLD
sell YIELD all            # Sell all YIELD tokens
buy YIELD 1h              # Buy at best rate from last hour
```

## 🔧 Management

### Service Management
```bash
# Check status
pm2 status
sudo systemctl status worldchain-trader

# View logs
pm2 logs
sudo journalctl -u worldchain-trader -f

# Restart service
pm2 restart worldchain-trader
sudo systemctl restart worldchain-trader

# Stop service
pm2 stop worldchain-trader
sudo systemctl stop worldchain-trader
```

### Updates
```bash
# Update the package
cd ~/worldchain-trader
git pull
npm install
```

## 🆘 Troubleshooting

### Common Issues

**"Cannot find module" Errors**
```bash
cd ~/worldchain-trader
npm install
./install-holdstation-sdk.sh
```

**Low ML Accuracy**
- Let it learn longer (48+ hours)
- Check if price database is running
- Verify internet connection

**No Auto-Trades Executing**
- Check confidence threshold (try 70%)
- Verify auto-trading mode is enabled
- Confirm sufficient WLD balance

**HoldStation SDK Issues**
```bash
npm install @holdstation/worldchain-sdk@latest
npm install @holdstation/worldchain-ethers-v6@latest
```

### Performance Optimization
- **VPS Hosting**: Better connectivity and uptime
- **4GB+ RAM**: Recommended for ML processing
- **SSD Storage**: Faster data access for AI models

## 📞 Support

### Getting Help
1. **Documentation**: Check this README first
2. **GitHub Issues**: Report bugs or request features
3. **In-App Help**: Built-in tutorials and guides

### Safety Reminders
- **Start with Learning Mode** for 24+ hours minimum
- **Use tiny amounts** (0.01 WLD) when first testing auto-trading
- **Monitor closely** during the first week of operation
- **Never invest** more than you can afford to lose completely

## ⚠️ Important Disclaimers

### Financial Risks
- **Real Money Trading**: This bot uses real cryptocurrency
- **No Profit Guarantees**: Past performance doesn't predict future results
- **Market Volatility**: Crypto markets are highly volatile
- **Start Small**: Always begin with amounts you can afford to lose

### Technical Considerations
- **Beta Software**: May contain bugs or unexpected behavior
- **Machine Learning Limitations**: AI predictions can be wrong
- **Internet Dependency**: Requires stable internet connection
- **Continuous Monitoring**: Regular supervision recommended

---

## 🚀 Quick Start Checklist

- [ ] Run Ubuntu installer: `./install-ubuntu.sh`
- [ ] Configure `.env` file with your wallet and API keys
- [ ] Start with Learning Mode for 24+ hours
- [ ] Monitor ML accuracy until it reaches 60%+
- [ ] Enable auto-trading with 0.01 WLD max position
- [ ] Set confidence threshold to 75%
- [ ] Monitor performance daily for first week
- [ ] Scale up gradually based on results

**Ready to start your AI trading journey? Install now and let machine learning optimize your Worldchain trading!**

---

*⚠️ Trading cryptocurrency involves substantial risk of loss. This software is provided "as is" without warranties. Always trade responsibly and never risk more than you can afford to lose.*