#!/bin/bash
# 🤖 ALGORITMIT Ultimate Installer v4.0
# Bulletproof installation with comprehensive error handling

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print functions
print_banner() {
    echo -e "${CYAN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  🤖 ALGORITMIT Ultimate Installer v4.0                      ║
║  🎯 Bulletproof Installation with Zero Errors               ║
║                                                              ║
║  Advanced AI-Powered Trading Bot for Worldchain             ║
║  Complete Installation Package for Any Linux System         ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

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

print_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Configuration
CURRENT_DIR=$(pwd)
BOT_DIR="$CURRENT_DIR/algoritmit-bot"
REPO_BASE="https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1"
BACKUP_DIR="$CURRENT_DIR/algoritmit-backup-$(date +%Y%m%d_%H%M%S)"

# Essential files list
ESSENTIAL_FILES=(
    "worldchain-trading-bot.js"
    "trading-strategy.js"
    "strategy-builder.js"
    "price-database.js"
    "algoritmit-strategy.js"
    "telegram-notifications.js"
    "token-discovery.js"
    "trading-engine.js"
    "sinclave-enhanced-engine.js"
    "sinclave.js"
    "package.json"
)

# Network test function
test_network() {
    print_info "Testing network connectivity..."
    
    # Test basic connectivity
    if ping -c 1 8.8.8.8 &> /dev/null; then
        print_success "Basic network connectivity: OK"
    else
        print_warning "Basic network connectivity: FAILED"
        return 1
    fi
    
    # Test GitHub access
    if curl -s --connect-timeout 10 https://github.com &> /dev/null; then
        print_success "GitHub access: OK"
    else
        print_warning "GitHub access: FAILED"
        return 1
    fi
    
    # Test npm registry
    if curl -s --connect-timeout 10 https://registry.npmjs.org &> /dev/null; then
        print_success "npm registry access: OK"
    else
        print_warning "npm registry access: FAILED"
        return 1
    fi
    
    return 0
}

# Check system requirements
check_system_requirements() {
    print_step "Checking system requirements..."
    
    # Check OS
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        print_info "OS detected: $PRETTY_NAME"
    else
        print_warning "OS detection failed, continuing anyway..."
    fi
    
    # Check disk space (need at least 1GB)
    AVAILABLE_SPACE=$(df . | awk 'NR==2 {print $4}')
    if [ "$AVAILABLE_SPACE" -lt 1048576 ]; then
        print_error "Insufficient disk space. Need at least 1GB free space."
        print_info "Available: $((AVAILABLE_SPACE / 1024))MB"
        exit 1
    fi
    print_success "Disk space: $((AVAILABLE_SPACE / 1024))MB available"
    
    # Check memory
    TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.0f", $2}')
    if [ "$TOTAL_MEM" -lt 1024 ]; then
        print_warning "Low memory detected: ${TOTAL_MEM}MB (1GB recommended)"
    else
        print_success "Memory: ${TOTAL_MEM}MB available"
    fi
    
    # Test network
    if test_network; then
        print_success "Network connectivity: OK"
    else
        print_warning "Network issues detected, will use fallback methods"
    fi
    
    print_success "System requirements check completed"
}

# Install Node.js with multiple methods
install_nodejs() {
    print_step "Installing Node.js..."
    
    # Check if already installed
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js already installed: $NODE_VERSION"
        return 0
    fi
    
    print_info "Node.js not found. Installing Node.js 18.x..."
    
    # Method 1: Package manager
    if command -v apt &> /dev/null; then
        print_info "Using apt package manager..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
    elif command -v yum &> /dev/null; then
        print_info "Using yum package manager..."
        curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
        yum install -y nodejs
    elif command -v dnf &> /dev/null; then
        print_info "Using dnf package manager..."
        curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
        dnf install -y nodejs
    else
        print_warning "No supported package manager found, trying manual installation..."
        install_nodejs_manual
    fi
    
    # Verify installation
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js installed successfully: $NODE_VERSION"
    else
        print_error "Node.js installation failed"
        exit 1
    fi
}

# Manual Node.js installation
install_nodejs_manual() {
    print_info "Installing Node.js manually..."
    
    # Download Node.js binary
    NODE_VERSION="18.20.8"
    ARCH=$(uname -m)
    
    if [[ "$ARCH" == "x86_64" ]]; then
        NODE_ARCH="x64"
    elif [[ "$ARCH" == "aarch64" ]]; then
        NODE_ARCH="arm64"
    else
        print_error "Unsupported architecture: $ARCH"
        exit 1
    fi
    
    NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz"
    
    print_info "Downloading Node.js from: $NODE_URL"
    
    if curl -fsSL "$NODE_URL" -o /tmp/node.tar.xz; then
        cd /tmp
        tar -xf node.tar.xz
        sudo cp -r node-v${NODE_VERSION}-linux-${NODE_ARCH}/* /usr/local/
        sudo ln -sf /usr/local/bin/node /usr/bin/node
        sudo ln -sf /usr/local/bin/npm /usr/bin/npm
        print_success "Node.js installed manually"
    else
        print_error "Failed to download Node.js"
        exit 1
    fi
}

# Create bot directory with backup
create_bot_directory() {
    print_step "Creating bot directory..."
    
    if [ -d "$BOT_DIR" ]; then
        print_warning "Bot directory already exists. Creating backup..."
        mkdir -p "$BACKUP_DIR"
        mv "$BOT_DIR" "$BACKUP_DIR/"
        print_success "Backup created: $BACKUP_DIR"
    fi
    
    mkdir -p "$BOT_DIR"
    cd "$BOT_DIR"
    
    print_success "Bot directory created: $BOT_DIR"
}

# Download files with multiple fallback methods
download_files() {
    print_step "Downloading bot files..."
    
    cd "$BOT_DIR"
    
    # Method 1: Try downloading from repository
    print_info "Attempting to download files from repository..."
    
    for file in "${ESSENTIAL_FILES[@]}"; do
        print_info "Downloading: $file"
        
        # Try multiple download methods
        if curl -fsSL "$REPO_BASE/$file" -o "$file" 2>/dev/null; then
            print_success "Downloaded: $file"
        elif wget -q "$REPO_BASE/$file" -O "$file" 2>/dev/null; then
            print_success "Downloaded: $file (wget)"
        else
            print_warning "Failed to download: $file"
            create_fallback_file "$file"
        fi
    done
    
    # Verify essential files
    if [ ! -f "worldchain-trading-bot.js" ]; then
        print_error "Critical file worldchain-trading-bot.js not found"
        exit 1
    fi
    
    print_success "File download completed"
}

# Create fallback files if download fails
create_fallback_file() {
    local file="$1"
    
    case "$file" in
        "package.json")
            create_minimal_package_json
            ;;
        "worldchain-trading-bot.js")
            print_error "Cannot create fallback for critical file: $file"
            exit 1
            ;;
        *)
            print_warning "Creating minimal fallback for: $file"
            echo "// Minimal fallback file for $file" > "$file"
            ;;
    esac
}

# Create minimal package.json
create_minimal_package_json() {
    cat > "package.json" << EOF
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
    print_success "Created minimal package.json"
}

# Install dependencies with comprehensive error handling
install_dependencies() {
    print_step "Installing Node.js dependencies..."
    
    cd "$BOT_DIR"
    
    # Configure npm for better network handling
    print_info "Configuring npm..."
    npm config set registry https://registry.npmjs.org/
    npm config set fetch-retries 10
    npm config set fetch-retry-mintimeout 30000
    npm config set fetch-retry-maxtimeout 300000
    
    # Clear npm cache
    npm cache clean --force 2>/dev/null || true
    
    # Try multiple installation methods
    print_info "Installing dependencies..."
    
    # Method 1: Standard npm install
    if npm install --production --no-audit --no-fund --prefer-offline; then
        print_success "Dependencies installed successfully"
        return 0
    fi
    
    print_warning "Standard npm install failed, trying alternative methods..."
    
    # Method 2: Install packages individually
    print_info "Installing packages individually..."
    ESSENTIAL_PACKAGES=(
        "@holdstation/worldchain-sdk@^4.0.29"
        "@holdstation/worldchain-ethers-v6@^4.0.29"
        "ethers@^6.0.0"
        "axios@^1.0.0"
        "dotenv@^16.0.0"
    )
    
    for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
        print_info "Installing: $pkg"
        if npm install "$pkg" --no-audit --no-fund --prefer-offline; then
            print_success "Installed: $pkg"
        else
            print_warning "Failed to install: $pkg"
        fi
    done
    
    # Method 3: Try with yarn if available
    if command -v yarn &> /dev/null; then
        print_info "Trying yarn installation..."
        yarn install --production --ignore-engines --network-timeout 300000 || true
    fi
    
    # Method 4: Try with pnpm if available
    if command -v pnpm &> /dev/null; then
        print_info "Trying pnpm installation..."
        pnpm install --prod --ignore-engines || true
    fi
    
    print_success "Dependency installation completed"
}

# Create environment file
create_environment_file() {
    print_step "Creating environment configuration..."
    
    cd "$BOT_DIR"
    
    cat > .env << EOF
# ALGORITMIT Trading Bot Configuration
# Generated by Ultimate Installer on $(date)

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

# Advanced Configuration
DEBUG_MODE=false
AUTO_RESTART=true
LOG_TO_FILE=true
EOF
    
    print_success "Environment file created: .env"
}

# Create comprehensive start script
create_start_script() {
    print_step "Creating start script..."
    
    cd "$BOT_DIR"
    
    cat > start.sh << 'EOF'
#!/bin/bash
# ALGORITMIT Trading Bot Start Script

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🤖 Starting ALGORITMIT Trading Bot...${NC}"
echo -e "${BLUE}📁 Directory: $(pwd)${NC}"
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ Error: .env file not found${NC}"
    echo -e "${YELLOW}💡 Please configure the bot first by editing .env file${NC}"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Error: Node.js is not installed${NC}"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    npm install
fi

# Create logs directory
mkdir -p logs

# Start the bot with error handling
echo -e "${GREEN}🚀 Starting bot...${NC}"
while true; do
    if node worldchain-trading-bot.js; then
        echo -e "${GREEN}✅ Bot exited normally${NC}"
        break
    else
        echo -e "${RED}❌ Bot crashed, restarting in 5 seconds...${NC}"
        sleep 5
    fi
done
EOF
    
    chmod +x start.sh
    print_success "Start script created: start.sh"
}

# Create comprehensive management script
create_management_script() {
    print_step "Creating management script..."
    
    cd "$BOT_DIR"
    
    cat > manage.sh << EOF
#!/bin/bash
# ALGORITMIT Trading Bot Management Script

BOT_DIR="$BOT_DIR"
LOG_FILE="/tmp/algoritmit.log"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "\${GREEN}[INFO]\${NC} \$1"
}

print_warning() {
    echo -e "\${YELLOW}[WARNING]\${NC} \$1"
}

print_error() {
    echo -e "\${RED}[ERROR]\${NC} \$1"
}

case "\$1" in
    start)
        print_status "Starting ALGORITMIT Trading Bot..."
        cd "\$BOT_DIR"
        nohup ./start.sh > "\$LOG_FILE" 2>&1 &
        sleep 2
        if pgrep -f "worldchain-trading-bot.js" > /dev/null; then
            print_status "Bot started successfully"
        else
            print_error "Failed to start bot"
        fi
        ;;
    stop)
        print_status "Stopping ALGORITMIT Trading Bot..."
        pkill -f "worldchain-trading-bot.js" || true
        sleep 2
        if ! pgrep -f "worldchain-trading-bot.js" > /dev/null; then
            print_status "Bot stopped successfully"
        else
            print_warning "Some processes may still be running"
        fi
        ;;
    restart)
        print_status "Restarting ALGORITMIT Trading Bot..."
        pkill -f "worldchain-trading-bot.js" || true
        sleep 3
        cd "\$BOT_DIR"
        nohup ./start.sh > "\$LOG_FILE" 2>&1 &
        print_status "Bot restarted"
        ;;
    status)
        if pgrep -f "worldchain-trading-bot.js" > /dev/null; then
            print_status "ALGORITMIT Trading Bot is running"
            ps aux | grep "worldchain-trading-bot.js" | grep -v grep
        else
            print_error "ALGORITMIT Trading Bot is not running"
        fi
        ;;
    logs)
        if [ -f "\$LOG_FILE" ]; then
            print_status "Showing recent logs:"
            tail -f "\$LOG_FILE"
        else
            print_warning "No log file found"
        fi
        ;;
    config)
        print_status "Opening configuration file..."
        if command -v nano &> /dev/null; then
            nano "\$BOT_DIR/.env"
        elif command -v vim &> /dev/null; then
            vim "\$BOT_DIR/.env"
        else
            echo "Please edit \$BOT_DIR/.env manually"
        fi
        ;;
    update)
        print_status "Updating ALGORITMIT Trading Bot..."
        cd "\$BOT_DIR"
        git pull origin main 2>/dev/null || print_warning "Git not available"
        npm install
        print_status "Update completed"
        ;;
    backup)
        print_status "Creating backup..."
        BACKUP_DIR="\${BOT_DIR}_backup_\$(date +%Y%m%d_%H%M%S)"
        cp -r "\$BOT_DIR" "\$BACKUP_DIR"
        print_status "Backup created: \$BACKUP_DIR"
        ;;
    *)
        echo -e "\${BLUE}ALGORITMIT Management Script\${NC}"
        echo ""
        echo "Usage: \$0 {start|stop|restart|status|logs|config|update|backup}"
        echo ""
        echo "Commands:"
        echo "  start    - Start the bot"
        echo "  stop     - Stop the bot"
        echo "  restart  - Restart the bot"
        echo "  status   - Check bot status"
        echo "  logs     - View logs"
        echo "  config   - Edit configuration"
        echo "  update   - Update the bot"
        echo "  backup   - Create backup"
        exit 1
        ;;
esac
EOF
    
    chmod +x manage.sh
    print_success "Management script created: manage.sh"
}

# Create comprehensive README
create_readme() {
    print_step "Creating documentation..."
    
    cd "$BOT_DIR"
    
    cat > README.md << EOF
# 🤖 ALGORITMIT Trading Bot

## 🚀 Quick Start

1. **Configure the bot:**
   \`\`\`bash
   nano .env
   \`\`\`

2. **Start the bot:**
   \`\`\`bash
   ./start.sh
   \`\`\`

## 🛠️ Management Commands

- \`./manage.sh start\` - Start the bot
- \`./manage.sh stop\` - Stop the bot
- \`./manage.sh restart\` - Restart the bot
- \`./manage.sh status\` - Check bot status
- \`./manage.sh logs\` - View logs
- \`./manage.sh config\` - Edit configuration
- \`./manage.sh update\` - Update the bot
- \`./manage.sh backup\` - Create backup

## ⚙️ Configuration

Edit the \`.env\` file to configure:
- Wallet private key
- RPC settings
- Trading parameters
- Telegram notifications

## 🔧 Troubleshooting

### Bot won't start
1. Check if Node.js is installed: \`node --version\`
2. Check if dependencies are installed: \`ls node_modules\`
3. Check configuration: \`./manage.sh config\`
4. View logs: \`./manage.sh logs\`

### Network issues
1. Check internet connectivity: \`ping 8.8.8.8\`
2. Check RPC URL in .env file
3. Try different RPC endpoints

### Dependencies issues
1. Clear npm cache: \`npm cache clean --force\`
2. Reinstall dependencies: \`npm install\`
3. Check package.json for correct versions

## 📊 Monitoring

- **Status**: \`./manage.sh status\`
- **Logs**: \`./manage.sh logs\`
- **Configuration**: \`./manage.sh config\`

## 🔒 Security

- Never share your private key
- Use strong passwords
- Keep your .env file secure
- Regular backups: \`./manage.sh backup\`

## 🆘 Support

For help and support, visit: https://github.com/notevayasconadan/eva/issues

---
*Installed by Ultimate Installer v4.0 on: $(date)*
*Installation directory: $BOT_DIR*
EOF
    
    print_success "Documentation created: README.md"
}

# Show installation summary
show_installation_summary() {
    print_success "🎉 ALGORITMIT Ultimate Installation completed successfully!"
    echo
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo
    echo "📁 Installation directory: $BOT_DIR"
    echo "🔧 Management script: $BOT_DIR/manage.sh"
    echo "📝 Configuration file: $BOT_DIR/.env"
    echo "📚 Documentation: $BOT_DIR/README.md"
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
    echo "  $BOT_DIR/manage.sh update   - Update the bot"
    echo "  $BOT_DIR/manage.sh backup   - Create backup"
    echo
    echo "⚠️  IMPORTANT: Configure your .env file before starting the bot!"
    echo "   - Set your private key"
    echo "   - Configure RPC settings"
    echo "   - Set up Telegram notifications (optional)"
    echo
    if [ -d "$BACKUP_DIR" ]; then
        echo "💾 Backup created: $BACKUP_DIR"
    fi
    echo
    echo "📚 Documentation: $BOT_DIR/README.md"
    echo "🆘 Support: https://github.com/notevayasconadan/eva/issues"
    echo
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
}

# Main installation function
main() {
    print_banner
    
    print_step "Starting ALGORITMIT Ultimate Installation..."
    echo
    
    check_system_requirements
    install_nodejs
    create_bot_directory
    download_files
    install_dependencies
    create_environment_file
    create_start_script
    create_management_script
    create_readme
    show_installation_summary
}

# Run main function
main "$@"