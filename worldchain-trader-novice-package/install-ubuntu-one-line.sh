#!/bin/bash

# Worldchain Trader Novice Package - One-Line Ubuntu Installer
# This script can be run directly from GitHub

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Installation variables
INSTALL_DIR="$HOME/worldchain-trader"
REPO_URL="https://github.com/notevayasconadan/eva.git"
PACKAGE_DIR="worldchain-trader-novice-package"

# Banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║           🚀 WORLDCHAIN TRADER NOVICE PACKAGE 🚀                             ║
║                                                                               ║
║              🎓 One-Line Ubuntu Installation 🎓                              ║
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

# Welcome message
show_welcome() {
    show_banner
    
    echo -e "${BOLD}${GREEN}🎯 ONE-LINE UBUNTU INSTALLATION FOR NOVICE TRADERS!${NC}"
    echo ""
    echo -e "${YELLOW}This installer will download and set up everything you need to start trading on Worldchain.${NC}"
    echo ""
    
    echo -e "${BOLD}${BLUE}🌟 WHAT WILL BE INSTALLED:${NC}"
    echo -e "${CYAN}   • Complete trading bot package${NC}"
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
    show_progress "Installing Node.js 18.x..."
    
    # Remove old Node.js if exists
    sudo apt remove -y nodejs npm 2>/dev/null || true
    
    # Add NodeSource repository
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    
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

# Download and install package
download_and_install_package() {
    show_progress "Downloading trading bot package..."
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Clone repository
    git clone "$REPO_URL" .
    
    # Check if package directory exists
    if [[ ! -d "$PACKAGE_DIR" ]]; then
        show_error "Package directory not found in repository"
        exit 1
    fi
    
    # Create installation directory
    mkdir -p "$INSTALL_DIR"
    
    # Copy package files
    cp -r "$PACKAGE_DIR"/* "$INSTALL_DIR/"
    
    # Clean up
    cd "$HOME"
    rm -rf "$TEMP_DIR"
    
    show_success "Package downloaded and installed"
}

# Install dependencies
install_dependencies() {
    show_progress "Installing npm dependencies..."
    
    cd "$INSTALL_DIR"
    npm install --production
    
    show_success "Dependencies installed"
}

# Install HoldStation SDK
install_holdstation_sdk() {
    show_progress "Installing HoldStation SDK..."
    
    cd "$INSTALL_DIR"
    
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
    
    cd "$INSTALL_DIR"
    
    if [[ ! -f ".env" ]]; then
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
    fi
    
    show_success "Environment file created"
}

# Create startup scripts
create_startup_scripts() {
    show_progress "Creating startup scripts..."
    
    cd "$INSTALL_DIR"
    
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

# Final setup and permissions
final_setup() {
    show_progress "Finalizing installation..."
    
    cd "$INSTALL_DIR"
    
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
    show_welcome
    check_system
    update_system
    install_essentials
    install_nodejs
    install_pm2
    download_and_install_package
    install_dependencies
    install_holdstation_sdk
    create_env_file
    create_startup_scripts
    create_systemd_service
    final_setup
    show_summary
}

# Run main function
main "$@"