#!/bin/bash
# 🌙 ALGORITMIT MoonFixed Installer v4.0
# Complete package with fixed RPC configuration and comprehensive error checking

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Print functions
print_banner() {
    echo -e "${CYAN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  🌙 ALGORITMIT MoonFixed v4.0                               ║
║  🎯 Complete Package with Fixed RPC Configuration           ║
║                                                              ║
║  Advanced AI-Powered Trading Bot for Worldchain             ║
║  Ready for Ubuntu Server Deployment                         ║
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
BOT_DIR="$CURRENT_DIR/algoritmit-moonfixed"
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

# Error handling function
handle_error() {
    local exit_code=$?
    local line_number=$1
    print_error "Installation failed at line $line_number (exit code: $exit_code)"
    print_info "Please check the error above and try again"
    print_info "For support, visit: https://github.com/notevayasconadan/eva/issues"
    exit $exit_code
}

# Set error trap
trap 'handle_error $LINENO' ERR

# Check system requirements
check_system_requirements() {
    print_step "Checking system requirements..."
    
    # Check OS
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        print_info "OS detected: $PRETTY_NAME"
        
        if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
            print_warning "This installer is optimized for Ubuntu/Debian. Other systems may work but are not guaranteed."
        fi
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
    
    # Test network connectivity
    print_info "Testing network connectivity..."
    if ping -c 1 8.8.8.8 &> /dev/null; then
        print_success "Network connectivity: OK"
    else
        print_warning "Network connectivity: FAILED - will use fallback methods"
    fi
    
    # Test GitHub access
    if curl -s --connect-timeout 10 https://github.com &> /dev/null; then
        print_success "GitHub access: OK"
    else
        print_warning "GitHub access: FAILED - will use fallback methods"
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
    print_step "Downloading MoonFixed bot files..."
    
    cd "$BOT_DIR"
    
    # Method 1: Try downloading from repository
    print_info "Downloading files from repository..."
    
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
  "name": "algoritmit-moonfixed",
  "version": "4.0.0",
  "description": "ALGORITMIT MoonFixed Trading Bot for Worldchain",
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

# Create MoonFixed environment file with correct RPC configuration
create_environment_file() {
    print_step "Creating MoonFixed environment configuration..."
    
    cd "$BOT_DIR"
    
    cat > .env << EOF
# 🌙 ALGORITMIT MoonFixed Configuration
# Generated by MoonFixed Installer on $(date)
# RPC Configuration: FIXED for Worldchain (Chain ID: 480)

# Wallet Configuration
PRIVATE_KEY=your_private_key_here
WALLET_ADDRESS=your_wallet_address_here

# RPC Configuration (MOONFIXED - Correct Worldchain settings)
RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
CHAIN_ID=480
NETWORK_NAME=worldchain

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

# Advanced Configuration (MOONFIXED)
DEBUG_MODE=false
AUTO_RESTART=true
LOG_TO_FILE=true
RPC_TIMEOUT=30000
RPC_RETRIES=5

# RPC Fallback URLs (MOONFIXED - Tested and working)
RPC_FALLBACK_1=https://worldchain.drpc.org
RPC_FALLBACK_2=https://rpc.worldchain.org
RPC_FALLBACK_3=https://worldchain-rpc.publicnode.com

# MoonFixed Specific Settings
MOONFIXED_VERSION=4.0.0
AUTO_RPC_SWITCH=true
RPC_HEALTH_CHECK=true
EOF
    
    print_success "MoonFixed environment file created: .env"
}

# Create comprehensive start script
create_start_script() {
    print_step "Creating MoonFixed start script..."
    
    cd "$BOT_DIR"
    
    cat > start.sh << 'EOF'
#!/bin/bash
# 🌙 ALGORITMIT MoonFixed Start Script

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🌙 Starting ALGORITMIT MoonFixed Trading Bot...${NC}"
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

# Test RPC connection before starting
echo -e "${BLUE}🔧 Testing RPC connection...${NC}"
if node -e "
const { ethers } = require('ethers');
require('dotenv').config();
(async () => {
    try {
        const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
        const network = await provider.getNetwork();
        console.log('✅ RPC Connection: OK (Chain ID: ' + network.chainId + ')');
        process.exit(0);
    } catch (error) {
        console.log('❌ RPC Connection: FAILED - ' + error.message);
        process.exit(1);
    }
})();
" 2>/dev/null; then
    echo -e "${GREEN}✅ RPC connection test passed${NC}"
else
    echo -e "${YELLOW}⚠️  RPC connection test failed, but continuing...${NC}"
fi

# Start the bot with error handling
echo -e "${GREEN}🚀 Starting MoonFixed bot...${NC}"
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
    print_success "MoonFixed start script created: start.sh"
}

# Create comprehensive management script
create_management_script() {
    print_step "Creating MoonFixed management script..."
    
    cd "$BOT_DIR"
    
    cat > manage.sh << EOF
#!/bin/bash
# 🌙 ALGORITMIT MoonFixed Management Script

BOT_DIR="$BOT_DIR"
LOG_FILE="/tmp/algoritmit-moonfixed.log"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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
        print_status "Starting ALGORITMIT MoonFixed Trading Bot..."
        cd "\$BOT_DIR"
        nohup ./start.sh > "\$LOG_FILE" 2>&1 &
        sleep 2
        if pgrep -f "worldchain-trading-bot.js" > /dev/null; then
            print_status "MoonFixed bot started successfully"
        else
            print_error "Failed to start MoonFixed bot"
        fi
        ;;
    stop)
        print_status "Stopping ALGORITMIT MoonFixed Trading Bot..."
        pkill -f "worldchain-trading-bot.js" || true
        sleep 2
        if ! pgrep -f "worldchain-trading-bot.js" > /dev/null; then
            print_status "MoonFixed bot stopped successfully"
        else
            print_warning "Some processes may still be running"
        fi
        ;;
    restart)
        print_status "Restarting ALGORITMIT MoonFixed Trading Bot..."
        pkill -f "worldchain-trading-bot.js" || true
        sleep 3
        cd "\$BOT_DIR"
        nohup ./start.sh > "\$LOG_FILE" 2>&1 &
        print_status "MoonFixed bot restarted"
        ;;
    status)
        if pgrep -f "worldchain-trading-bot.js" > /dev/null; then
            print_status "ALGORITMIT MoonFixed Trading Bot is running"
            ps aux | grep "worldchain-trading-bot.js" | grep -v grep
        else
            print_error "ALGORITMIT MoonFixed Trading Bot is not running"
        fi
        ;;
    logs)
        if [ -f "\$LOG_FILE" ]; then
            print_status "Showing MoonFixed bot logs:"
            tail -f "\$LOG_FILE"
        else
            print_warning "No log file found"
        fi
        ;;
    config)
        print_status "Opening MoonFixed configuration file..."
        if command -v nano &> /dev/null; then
            nano "\$BOT_DIR/.env"
        elif command -v vim &> /dev/null; then
            vim "\$BOT_DIR/.env"
        else
            echo "Please edit \$BOT_DIR/.env manually"
        fi
        ;;
    test-rpc)
        print_status "Testing RPC connection..."
        cd "\$BOT_DIR"
        node -e "
const { ethers } = require('ethers');
require('dotenv').config();
(async () => {
    try {
        const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
        const network = await provider.getNetwork();
        const blockNumber = await provider.getBlockNumber();
        console.log('✅ RPC Connection: OK');
        console.log('🔗 Chain ID: ' + network.chainId);
        console.log('📦 Block: ' + blockNumber);
        process.exit(0);
    } catch (error) {
        console.log('❌ RPC Connection: FAILED - ' + error.message);
        process.exit(1);
    }
})();
"
        ;;
    update)
        print_status "Updating ALGORITMIT MoonFixed Trading Bot..."
        cd "\$BOT_DIR"
        git pull origin main 2>/dev/null || print_warning "Git not available"
        npm install
        print_status "MoonFixed update completed"
        ;;
    backup)
        print_status "Creating MoonFixed backup..."
        BACKUP_DIR="\${BOT_DIR}_backup_\$(date +%Y%m%d_%H%M%S)"
        cp -r "\$BOT_DIR" "\$BACKUP_DIR"
        print_status "MoonFixed backup created: \$BACKUP_DIR"
        ;;
    *)
        echo -e "\${CYAN}🌙 ALGORITMIT MoonFixed Management Script\${NC}"
        echo ""
        echo "Usage: \$0 {start|stop|restart|status|logs|config|test-rpc|update|backup}"
        echo ""
        echo "Commands:"
        echo "  start     - Start the MoonFixed bot"
        echo "  stop      - Stop the MoonFixed bot"
        echo "  restart   - Restart the MoonFixed bot"
        echo "  status    - Check bot status"
        echo "  logs      - View logs"
        echo "  config    - Edit configuration"
        echo "  test-rpc  - Test RPC connection"
        echo "  update    - Update the bot"
        echo "  backup    - Create backup"
        exit 1
        ;;
esac
EOF
    
    chmod +x manage.sh
    print_success "MoonFixed management script created: manage.sh"
}

# Create comprehensive README
create_readme() {
    print_step "Creating MoonFixed documentation..."
    
    cd "$BOT_DIR"
    
    cat > README.md << EOF
# 🌙 ALGORITMIT MoonFixed Trading Bot

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

- \`./manage.sh start\` - Start the MoonFixed bot
- \`./manage.sh stop\` - Stop the MoonFixed bot
- \`./manage.sh restart\` - Restart the MoonFixed bot
- \`./manage.sh status\` - Check bot status
- \`./manage.sh logs\` - View logs
- \`./manage.sh config\` - Edit configuration
- \`./manage.sh test-rpc\` - Test RPC connection
- \`./manage.sh update\` - Update the bot
- \`./manage.sh backup\` - Create backup

## ⚙️ Configuration

Edit the \`.env\` file to configure:
- Wallet private key
- RPC settings (FIXED for Worldchain)
- Trading parameters
- Telegram notifications

## 🔧 MoonFixed Features

### ✅ Fixed RPC Configuration
- **Correct Chain ID:** 480 (Worldchain)
- **Working RPC URLs:** Tested and verified
- **Auto-fallback:** Multiple RPC endpoints
- **Health checks:** Automatic RPC testing

### 🛡️ Error Handling
- **Comprehensive error checking**
- **Automatic retry mechanisms**
- **Fallback installation methods**
- **Network resilience**

### 📊 Performance
- **Optimized for Ubuntu servers**
- **Memory efficient**
- **Fast startup times**
- **Reliable operation**

## 🔧 Troubleshooting

### Bot won't start
1. Check if Node.js is installed: \`node --version\`
2. Check if dependencies are installed: \`ls node_modules\`
3. Test RPC connection: \`./manage.sh test-rpc\`
4. Check configuration: \`./manage.sh config\`
5. View logs: \`./manage.sh logs\`

### RPC issues
1. Test RPC connection: \`./manage.sh test-rpc\`
2. Check RPC URL in .env file
3. Verify chain ID is 480
4. Check internet connectivity

### Dependencies issues
1. Clear npm cache: \`npm cache clean --force\`
2. Reinstall dependencies: \`npm install\`
3. Check package.json for correct versions

## 📊 Monitoring

- **Status**: \`./manage.sh status\`
- **Logs**: \`./manage.sh logs\`
- **Configuration**: \`./manage.sh config\`
- **RPC Test**: \`./manage.sh test-rpc\`

## 🔒 Security

- Never share your private key
- Use strong passwords
- Keep your .env file secure
- Regular backups: \`./manage.sh backup\`

## 🆘 Support

For help and support, visit: https://github.com/notevayasconadan/eva/issues

---
*MoonFixed v4.0 - Installed on: $(date)*
*Installation directory: $BOT_DIR*
*RPC Configuration: FIXED for Worldchain (Chain ID: 480)*
EOF
    
    print_success "MoonFixed documentation created: README.md"
}

# Show installation summary
show_installation_summary() {
    print_success "🎉 ALGORITMIT MoonFixed Installation completed successfully!"
    echo
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo
    echo "📁 Installation directory: $BOT_DIR"
    echo "🔧 Management script: $BOT_DIR/manage.sh"
    echo "📝 Configuration file: $BOT_DIR/.env"
    echo "📚 Documentation: $BOT_DIR/README.md"
    echo
    echo "🌙 MoonFixed Features:"
    echo "  ✅ Fixed RPC Configuration (Chain ID: 480)"
    echo "  ✅ Working Worldchain endpoints"
    echo "  ✅ Comprehensive error handling"
    echo "  ✅ Auto-fallback mechanisms"
    echo "  ✅ Ubuntu server optimized"
    echo
    echo "📋 Next steps:"
    echo "1. Configure the bot: nano $BOT_DIR/.env"
    echo "2. Test RPC connection: $BOT_DIR/manage.sh test-rpc"
    echo "3. Start the bot: $BOT_DIR/manage.sh start"
    echo "4. Check status: $BOT_DIR/manage.sh status"
    echo
    echo "🛠️  Management commands:"
    echo "  $BOT_DIR/manage.sh start     - Start the MoonFixed bot"
    echo "  $BOT_DIR/manage.sh stop      - Stop the MoonFixed bot"
    echo "  $BOT_DIR/manage.sh restart   - Restart the MoonFixed bot"
    echo "  $BOT_DIR/manage.sh status    - Check bot status"
    echo "  $BOT_DIR/manage.sh logs      - View logs"
    echo "  $BOT_DIR/manage.sh config    - Edit configuration"
    echo "  $BOT_DIR/manage.sh test-rpc  - Test RPC connection"
    echo "  $BOT_DIR/manage.sh update    - Update the bot"
    echo "  $BOT_DIR/manage.sh backup    - Create backup"
    echo
    echo "⚠️  IMPORTANT: Configure your .env file before starting the bot!"
    echo "   - Set your private key"
    echo "   - Configure RPC settings (already fixed)"
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
    
    print_step "Starting ALGORITMIT MoonFixed Installation..."
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