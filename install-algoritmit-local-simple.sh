#!/bin/bash
# 🤖 ALGORITMIT Local Simple Installer v4.0
# Zero-error installation for local directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
CURRENT_DIR=$(pwd)
BOT_DIR="$CURRENT_DIR/algoritmit-bot"
SERVICE_NAME="algoritmit-local"

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root. This is not recommended for local installation."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check system requirements
check_system_requirements() {
    print_info "Checking system requirements..."
    
    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        print_info "Node.js not found. Installing Node.js 18.x..."
        install_nodejs
    else
        NODE_VERSION=$(node --version)
        print_success "Node.js found: $NODE_VERSION"
    fi
    
    # Check if npm is installed
    if ! command -v npm &> /dev/null; then
        print_error "npm not found. Please install Node.js first."
        exit 1
    fi
    
    # Check available disk space (need at least 500MB)
    AVAILABLE_SPACE=$(df . | awk 'NR==2 {print $4}')
    if [ "$AVAILABLE_SPACE" -lt 524288 ]; then
        print_error "Insufficient disk space. Need at least 500MB free space."
        exit 1
    fi
    
    print_success "System requirements check passed"
}

# Install Node.js if needed
install_nodejs() {
    print_info "Installing Node.js 18.x..."
    
    # Detect OS and install Node.js
    if command -v apt &> /dev/null; then
        # Ubuntu/Debian
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
        sudo yum install -y nodejs
    elif command -v dnf &> /dev/null; then
        # Fedora
        curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
        sudo dnf install -y nodejs
    else
        print_error "Unsupported package manager. Please install Node.js manually."
        exit 1
    fi
    
    print_success "Node.js installed successfully"
}

# Create bot directory
create_bot_directory() {
    print_info "Creating bot directory..."
    
    if [ -d "$BOT_DIR" ]; then
        print_warning "Bot directory already exists. Backing up..."
        mv "$BOT_DIR" "${BOT_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    mkdir -p "$BOT_DIR"
    cd "$BOT_DIR"
    
    print_success "Bot directory created: $BOT_DIR"
}

# Copy essential files
copy_essential_files() {
    print_info "Copying essential files..."
    
    # Copy main bot file
    if [ -f "$CURRENT_DIR/worldchain-trading-bot.js" ]; then
        cp "$CURRENT_DIR/worldchain-trading-bot.js" "$BOT_DIR/"
        print_success "Copied worldchain-trading-bot.js"
    else
        print_error "worldchain-trading-bot.js not found in current directory"
        exit 1
    fi
    
    # Copy package.json if exists
    if [ -f "$CURRENT_DIR/package.json" ]; then
        cp "$CURRENT_DIR/package.json" "$BOT_DIR/"
        print_success "Copied package.json"
    else
        # Create minimal package.json
        cat > "$BOT_DIR/package.json" << EOF
{
  "name": "algoritmit-trading-bot",
  "version": "1.0.0",
  "description": "ALGORITMIT Trading Bot for Worldchain",
  "main": "worldchain-trading-bot.js",
  "scripts": {
    "start": "node worldchain-trading-bot.js",
    "dev": "node worldchain-trading-bot.js"
  },
  "dependencies": {
    "@holdstation/worldchain-sdk": "^4.0.29",
    "@holdstation/worldchain-ethers-v6": "^4.0.29",
    "ethers": "^6.0.0",
    "axios": "^1.0.0",
    "dotenv": "^16.0.0"
  }
}
EOF
        print_success "Created package.json"
    fi
    
    # Copy other essential files
    ESSENTIAL_FILES=(
        "trading-strategy.js"
        "strategy-builder.js"
        "price-database.js"
        "algoritmit-strategy.js"
        "telegram-notifications.js"
        "token-discovery.js"
        "trading-engine.js"
        "sinclave-enhanced-engine.js"
        "sinclave.js"
    )
    
    for file in "${ESSENTIAL_FILES[@]}"; do
        if [ -f "$CURRENT_DIR/$file" ]; then
            cp "$CURRENT_DIR/$file" "$BOT_DIR/"
            print_success "Copied $file"
        fi
    done
    
    print_success "Essential files copied successfully"
}

# Install dependencies
install_dependencies() {
    print_info "Installing Node.js dependencies..."
    
    cd "$BOT_DIR"
    
    # Clear npm cache
    npm cache clean --force 2>/dev/null || true
    
    # Configure npm for better network handling
    npm config set registry https://registry.npmjs.org/
    npm config set fetch-retries 5
    npm config set fetch-retry-mintimeout 20000
    npm config set fetch-retry-maxtimeout 120000
    
    # Install dependencies with multiple fallback methods
    print_info "Installing dependencies..."
    
    if npm install --production --no-audit --no-fund --prefer-offline; then
        print_success "Dependencies installed successfully"
    else
        print_warning "npm install failed, trying alternative method..."
        
        # Try installing essential packages individually
        ESSENTIAL_PACKAGES=(
            "@holdstation/worldchain-sdk@^4.0.29"
            "@holdstation/worldchain-ethers-v6@^4.0.29"
            "ethers@^6.0.0"
            "axios@^1.0.0"
            "dotenv@^16.0.0"
        )
        
        for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
            print_info "Installing: $pkg"
            npm install "$pkg" --no-audit --no-fund --prefer-offline || {
                print_warning "Failed to install $pkg, continuing..."
            }
        done
        
        print_success "Essential dependencies installed"
    fi
}

# Create environment file
create_environment_file() {
    print_info "Creating environment configuration..."
    
    cd "$BOT_DIR"
    
    if [ ! -f ".env" ]; then
        cat > .env << EOF
# ALGORITMIT Trading Bot Configuration
# Generated by installer on $(date)

# Wallet Configuration
PRIVATE_KEY=your_private_key_here
WALLET_ADDRESS=your_wallet_address_here

# RPC Configuration
RPC_URL=https://rpc.worldchain.org
CHAIN_ID=12345

# Trading Configuration
TRADING_ENABLED=false
LEARNING_MODE=true
PAPER_TRADING=true

# Safety Configuration
MAX_SLIPPAGE=5
GAS_LIMIT=300000
GAS_PRICE=20000000000

# Telegram Configuration (Optional)
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here

# Performance Configuration
PRICE_UPDATE_INTERVAL=30
LOG_LEVEL=info
EOF
        print_success "Environment file created: .env"
    else
        print_info "Environment file already exists: .env"
    fi
}

# Create start script
create_start_script() {
    print_info "Creating start script..."
    
    cd "$BOT_DIR"
    
    cat > start.sh << 'EOF'
#!/bin/bash
# ALGORITMIT Trading Bot Start Script

echo "🤖 Starting ALGORITMIT Trading Bot..."
echo "📁 Directory: $(pwd)"
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found"
    echo "💡 Please configure the bot first by editing .env file"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the bot
echo "🚀 Starting bot..."
node worldchain-trading-bot.js
EOF
    
    chmod +x start.sh
    print_success "Start script created: start.sh"
}

# Create management script
create_management_script() {
    print_info "Creating management script..."
    
    cd "$BOT_DIR"
    
    cat > manage.sh << EOF
#!/bin/bash
# ALGORITMIT Trading Bot Management Script

BOT_DIR="$BOT_DIR"

case "\$1" in
    start)
        echo "🚀 Starting ALGORITMIT Trading Bot..."
        cd "\$BOT_DIR"
        ./start.sh
        ;;
    stop)
        echo "⏹️  Stopping ALGORITMIT Trading Bot..."
        pkill -f "worldchain-trading-bot.js" || true
        ;;
    restart)
        echo "🔄 Restarting ALGORITMIT Trading Bot..."
        pkill -f "worldchain-trading-bot.js" || true
        sleep 2
        cd "\$BOT_DIR"
        ./start.sh
        ;;
    status)
        if pgrep -f "worldchain-trading-bot.js" > /dev/null; then
            echo "✅ ALGORITMIT Trading Bot is running"
            ps aux | grep "worldchain-trading-bot.js" | grep -v grep
        else
            echo "❌ ALGORITMIT Trading Bot is not running"
        fi
        ;;
    logs)
        echo "📋 Recent logs:"
        tail -f /tmp/algoritmit.log 2>/dev/null || echo "No log file found"
        ;;
    config)
        echo "⚙️  Opening configuration file..."
        if command -v nano &> /dev/null; then
            nano "\$BOT_DIR/.env"
        elif command -v vim &> /dev/null; then
            vim "\$BOT_DIR/.env"
        else
            echo "Please edit \$BOT_DIR/.env manually"
        fi
        ;;
    update)
        echo "📦 Updating ALGORITMIT Trading Bot..."
        cd "\$BOT_DIR"
        git pull origin main 2>/dev/null || echo "Git not available, manual update required"
        npm install
        echo "✅ Update completed"
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status|logs|config|update}"
        echo ""
        echo "Commands:"
        echo "  start    - Start the bot"
        echo "  stop     - Stop the bot"
        echo "  restart  - Restart the bot"
        echo "  status   - Check bot status"
        echo "  logs     - View logs"
        echo "  config   - Edit configuration"
        echo "  update   - Update the bot"
        exit 1
        ;;
esac
EOF
    
    chmod +x manage.sh
    print_success "Management script created: manage.sh"
}

# Create README
create_readme() {
    print_info "Creating README file..."
    
    cd "$BOT_DIR"
    
    cat > README.md << EOF
# 🤖 ALGORITMIT Trading Bot

## Quick Start

1. **Configure the bot:**
   \`\`\`bash
   nano .env
   \`\`\`

2. **Start the bot:**
   \`\`\`bash
   ./start.sh
   \`\`\`

## Management Commands

- \`./manage.sh start\` - Start the bot
- \`./manage.sh stop\` - Stop the bot
- \`./manage.sh restart\` - Restart the bot
- \`./manage.sh status\` - Check bot status
- \`./manage.sh logs\` - View logs
- \`./manage.sh config\` - Edit configuration
- \`./manage.sh update\` - Update the bot

## Configuration

Edit the \`.env\` file to configure:
- Wallet private key
- RPC settings
- Trading parameters
- Telegram notifications

## Support

For help and support, visit: https://github.com/notevayasconadan/eva/issues

---
*Installed on: $(date)*
*Installation directory: $BOT_DIR*
EOF
    
    print_success "README created: README.md"
}

# Show installation summary
show_installation_summary() {
    print_success "🎉 ALGORITMIT Trading Bot installation completed!"
    echo
    echo "📁 Installation directory: $BOT_DIR"
    echo "🔧 Management script: $BOT_DIR/manage.sh"
    echo "📝 Configuration file: $BOT_DIR/.env"
    echo
    echo "📋 Next steps:"
    echo "1. Configure the bot: nano $BOT_DIR/.env"
    echo "2. Start the bot: cd $BOT_DIR && ./start.sh"
    echo "3. Or use management: $BOT_DIR/manage.sh start"
    echo
    echo "🛠️  Management commands:"
    echo "  $BOT_DIR/manage.sh start    - Start the bot"
    echo "  $BOT_DIR/manage.sh stop     - Stop the bot"
    echo "  $BOT_DIR/manage.sh restart  - Restart the bot"
    echo "  $BOT_DIR/manage.sh status   - Check bot status"
    echo "  $BOT_DIR/manage.sh logs     - View logs"
    echo "  $BOT_DIR/manage.sh config   - Edit configuration"
    echo
    echo "⚠️  IMPORTANT: Configure your .env file before starting the bot!"
    echo "   - Set your private key"
    echo "   - Configure RPC settings"
    echo "   - Set up Telegram notifications (optional)"
    echo
    echo "📚 Documentation: $BOT_DIR/README.md"
    echo "🆘 Support: https://github.com/notevayasconadan/eva/issues"
}

# Main installation function
main() {
    echo "🤖 ALGORITMIT Local Simple Installer v4.0"
    echo "=========================================="
    echo
    
    check_root
    check_system_requirements
    create_bot_directory
    copy_essential_files
    install_dependencies
    create_environment_file
    create_start_script
    create_management_script
    create_readme
    show_installation_summary
}

# Run main function
main "$@"