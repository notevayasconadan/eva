#!/bin/bash

# Worldchain Trader Novice Package - Ubuntu Installation Script
# Complete automated installation for novice traders

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Installation variables
INSTALL_DIR="$HOME/worldchain-trader"
LOG_FILE="$INSTALL_DIR/install.log"
NODE_VERSION="18.x"
NPM_VERSION="latest"

# Banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║           🚀 WORLDCHAIN TRADER NOVICE PACKAGE 🚀                             ║
║                                                                               ║
║              🎓 Complete Ubuntu Installation 🎓                              ║
║             🧠 AI-Powered Trading Bot 🧠                                     ║
║            🛡️ Zero Configuration Required 🛡️                                ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Progress indicators
show_progress() {
    echo -e "${CYAN}▶ $1${NC}"
}

show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

show_error() {
    echo -e "${RED}❌ $1${NC}"
}

show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Welcome message
show_welcome() {
    show_banner
    
    echo -e "${BOLD}${GREEN}🎯 COMPLETE UBUNTU INSTALLATION FOR NOVICE TRADERS!${NC}"
    echo ""
    echo -e "${YELLOW}This installer will set up everything you need to start trading on Worldchain.${NC}"
    echo ""
    
    echo -e "${BOLD}${BLUE}🌟 WHAT WILL BE INSTALLED:${NC}"
    echo -e "${CYAN}   • Node.js 18.x (Latest LTS)${NC}"
    echo -e "${CYAN}   • All trading bot dependencies${NC}"
    echo -e "${CYAN}   • HoldStation SDK for Worldchain${NC}"
    echo -e "${CYAN}   • AI-powered trading strategies${NC}"
    echo -e "${CYAN}   • Telegram notifications${NC}"
    echo -e "${CYAN}   • Complete configuration files${NC}"
    echo ""
    
    echo -e "${BOLD}${RED}⚠️  IMPORTANT SAFETY REMINDERS:${NC}"
    echo -e "${YELLOW}   • Only trade with money you can afford to lose${NC}"
    echo -e "${YELLOW}   • Start with very small amounts (0.05-0.1 WLD)${NC}"
    echo -e "${YELLOW}   • This is experimental software${NC}"
    echo -e "${YELLOW}   • Always do your own research${NC}"
    echo ""
    
    echo -e "${BOLD}${GREEN}🚀 Starting installation in 3 seconds...${NC}"
    sleep 3
}

# Check system requirements
check_system() {
    show_progress "Checking system requirements..."
    
    # Check OS
    if [[ ! -f /etc/os-release ]]; then
        show_error "This installer is designed for Ubuntu/Debian systems"
        exit 1
    fi
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        show_warning "Running as root is not recommended for security reasons"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check available disk space (need at least 1GB)
    AVAILABLE_SPACE=$(df "$HOME" | awk 'NR==2 {print $4}')
    if [[ $AVAILABLE_SPACE -lt 1048576 ]]; then
        show_error "Insufficient disk space. Need at least 1GB available."
        exit 1
    fi
    
    show_success "System requirements met"
}

# Update system packages
update_system() {
    show_progress "Updating system packages..."
    
    sudo apt update -qq
    sudo apt upgrade -y -qq
    
    show_success "System packages updated"
}

# Install essential packages
install_essentials() {
    show_progress "Installing essential packages..."
    
    sudo apt install -y -qq \
        curl \
        wget \
        git \
        build-essential \
        python3 \
        python3-pip \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common
    
    show_success "Essential packages installed"
}

# Install Node.js
install_nodejs() {
    show_progress "Installing Node.js $NODE_VERSION..."
    
    # Remove old Node.js if exists
    sudo apt remove -y nodejs npm 2>/dev/null || true
    
    # Add NodeSource repository
    curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION | sudo -E bash -
    
    # Install Node.js
    sudo apt install -y nodejs
    
    # Verify installation
    NODE_VER=$(node --version)
    NPM_VER=$(npm --version)
    
    show_success "Node.js $NODE_VER and npm $NPM_VER installed"
}

# Install PM2 for process management
install_pm2() {
    show_progress "Installing PM2 process manager..."
    
    sudo npm install -g pm2@latest
    
    show_success "PM2 installed"
}

# Create installation directory
create_install_directory() {
    show_progress "Creating installation directory..."
    
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    show_success "Installation directory created: $INSTALL_DIR"
}

# Copy package files
copy_package_files() {
    show_progress "Copying package files..."
    
    # Copy all JavaScript files
    cp -r ../*.js . 2>/dev/null || true
    
    # Copy configuration files
    cp ../package.json . 2>/dev/null || true
    cp ../.env.example . 2>/dev/null || true
    cp ../.gitignore . 2>/dev/null || true
    
    # Copy documentation
    cp ../*.md . 2>/dev/null || true
    
    # Copy installation scripts
    cp ../install-holdstation-sdk.sh . 2>/dev/null || true
    cp ../setup-novice.sh . 2>/dev/null || true
    
    show_success "Package files copied"
}

# Install npm dependencies
install_dependencies() {
    show_progress "Installing npm dependencies..."
    
    npm install --production
    
    show_success "Dependencies installed"
}

# Install HoldStation SDK
install_holdstation_sdk() {
    show_progress "Installing HoldStation SDK..."
    
    if [[ -f "install-holdstation-sdk.sh" ]]; then
        chmod +x install-holdstation-sdk.sh
        ./install-holdstation-sdk.sh
    else
        npm install @holdstation/worldchain-sdk@latest
        npm install @holdstation/worldchain-ethers-v6@latest
    fi
    
    show_success "HoldStation SDK installed"
}

# Create environment file
create_env_file() {
    show_progress "Creating environment configuration..."
    
    if [[ ! -f ".env" ]]; then
        cp .env.example .env 2>/dev/null || {
            cat > .env << 'EOF'
# Worldchain Trader Configuration
# Replace with your actual values

# Wallet Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key

# Trading Configuration
MAX_POSITION_SIZE=0.1
SLIPPAGE_TOLERANCE=5
GAS_LIMIT=300000

# AI Trading Settings
ML_CONFIDENCE_THRESHOLD=75
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false

# Telegram Notifications (Optional)
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Safety Settings
ENABLE_STOP_LOSS=true
STOP_LOSS_PERCENTAGE=10
MAX_DAILY_TRADES=10
EOF
        }
    fi
    
    show_success "Environment file created"
}

# Create startup scripts
create_startup_scripts() {
    show_progress "Creating startup scripts..."
    
    # Main startup script
    cat > start-trader.sh << 'EOF'
#!/bin/bash

# Worldchain Trader Startup Script
cd "$(dirname "$0")"

echo "🚀 Starting Worldchain Trader..."
echo "📊 AI-Powered Trading Bot for Novice Traders"
echo ""

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo "❌ Configuration file (.env) not found!"
    echo "Please run: ./setup-novice.sh"
    exit 1
fi

# Start the trading bot
node worldchain-trading-bot.js
EOF

    # PM2 startup script
    cat > start-pm2.sh << 'EOF'
#!/bin/bash

# Worldchain Trader PM2 Startup Script
cd "$(dirname "$0")"

echo "🚀 Starting Worldchain Trader with PM2..."
echo "📊 AI-Powered Trading Bot for Novice Traders"
echo ""

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo "❌ Configuration file (.env) not found!"
    echo "Please run: ./setup-novice.sh"
    exit 1
fi

# Start with PM2
pm2 start worldchain-trading-bot.js --name "worldchain-trader"

echo "✅ Trader started with PM2"
echo "📋 Commands:"
echo "   pm2 status          - Check status"
echo "   pm2 logs            - View logs"
echo "   pm2 stop            - Stop trader"
echo "   pm2 restart         - Restart trader"
EOF

    # Setup script
    cat > setup-novice.sh << 'EOF'
#!/bin/bash

# Worldchain Trader Novice Setup Script
cd "$(dirname "$0")"

echo "🎓 Worldchain Trader Novice Setup"
echo "=================================="
echo ""

# Check if .env exists
if [[ -f ".env" ]]; then
    echo "✅ Configuration file found"
else
    echo "❌ Configuration file not found. Creating..."
    cp .env.example .env 2>/dev/null || {
        echo "Creating basic .env file..."
        cat > .env << 'ENVEOF'
# Worldchain Trader Configuration
# Replace with your actual values

# Wallet Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key

# Trading Configuration
MAX_POSITION_SIZE=0.1
SLIPPAGE_TOLERANCE=5
GAS_LIMIT=300000

# AI Trading Settings
ML_CONFIDENCE_THRESHOLD=75
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false

# Telegram Notifications (Optional)
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Safety Settings
ENABLE_STOP_LOSS=true
STOP_LOSS_PERCENTAGE=10
MAX_DAILY_TRADES=10
ENVEOF
    }
fi

echo ""
echo "📝 Next Steps:"
echo "1. Edit .env file with your wallet private key"
echo "2. Add your Alchemy API key"
echo "3. Configure trading parameters"
echo "4. Run: ./start-trader.sh"
echo ""
echo "⚠️  IMPORTANT: Never share your private key!"
echo "⚠️  Start with small amounts (0.05-0.1 WLD)"
echo ""
echo "📚 Documentation: README.md"
EOF

    # Make scripts executable
    chmod +x start-trader.sh start-pm2.sh setup-novice.sh
    
    show_success "Startup scripts created"
}

# Create systemd service
create_systemd_service() {
    show_progress "Creating systemd service..."
    
    sudo tee /etc/systemd/system/worldchain-trader.service > /dev/null << EOF
[Unit]
Description=Worldchain Trader Bot
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd
    sudo systemctl daemon-reload
    
    show_success "Systemd service created"
}

# Create comprehensive README
create_readme() {
    show_progress "Creating comprehensive documentation..."
    
    cat > README.md << 'EOF'
# 🚀 Worldchain Trader Novice Package

**Complete AI-powered trading bot for Worldchain - Perfect for Ubuntu beginners!**

## 🎯 Quick Start

### One-Command Installation
```bash
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/main/install-ubuntu.sh | bash
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
EOF

    show_success "Documentation created"
}

# Final setup and permissions
final_setup() {
    show_progress "Finalizing installation..."
    
    # Set proper permissions
    chmod -R 755 "$INSTALL_DIR"
    chmod 600 "$INSTALL_DIR/.env" 2>/dev/null || true
    
    # Create log directory
    mkdir -p "$INSTALL_DIR/logs"
    
    show_success "Installation finalized"
}

# Installation summary
show_summary() {
    show_banner
    
    echo -e "${BOLD}${GREEN}🎉 INSTALLATION COMPLETE! 🎉${NC}"
    echo ""
    echo -e "${BOLD}${BLUE}📁 Installation Directory:${NC} $INSTALL_DIR"
    echo -e "${BOLD}${BLUE}📝 Log File:${NC} $LOG_FILE"
    echo ""
    
    echo -e "${BOLD}${YELLOW}🚀 NEXT STEPS:${NC}"
    echo -e "${CYAN}1. Navigate to installation directory:${NC}"
    echo -e "   cd $INSTALL_DIR"
    echo ""
    echo -e "${CYAN}2. Configure your wallet:${NC}"
    echo -e "   ./setup-novice.sh"
    echo -e "   nano .env"
    echo ""
    echo -e "${CYAN}3. Start the trading bot:${NC}"
    echo -e "   ./start-trader.sh"
    echo ""
    
    echo -e "${BOLD}${RED}⚠️  IMPORTANT SAFETY REMINDERS:${NC}"
    echo -e "${YELLOW}   • Start with Learning Mode for 24+ hours${NC}"
    echo -e "${YELLOW}   • Use very small amounts (0.01-0.05 WLD) initially${NC}"
    echo -e "${YELLOW}   • Never share your private key${NC}"
    echo -e "${YELLOW}   • Monitor performance closely${NC}"
    echo ""
    
    echo -e "${BOLD}${GREEN}📚 Documentation:${NC} $INSTALL_DIR/README.md"
    echo -e "${BOLD}${GREEN}🔧 Management:${NC} pm2 status, pm2 logs, pm2 restart"
    echo ""
    
    echo -e "${BOLD}${CYAN}🎯 Happy Trading! 🎯${NC}"
}

# Main installation function
main() {
    # Log everything
    exec > >(tee -a "$LOG_FILE") 2>&1
    
    show_welcome
    check_system
    update_system
    install_essentials
    install_nodejs
    install_pm2
    create_install_directory
    copy_package_files
    install_dependencies
    install_holdstation_sdk
    create_env_file
    create_startup_scripts
    create_systemd_service
    create_readme
    final_setup
    show_summary
}

# Run main function
main "$@"