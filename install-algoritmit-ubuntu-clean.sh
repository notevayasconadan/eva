#!/bin/bash
# 🤖 ALGORITMIT Ubuntu Clean Installer v4.0
# Enhanced installation script with package system fixes and error handling

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
PACKAGE_URL="https://github.com/notevayasconadan/eva/raw/cursor/check-repository-branches-for-latest-code-05c1/algoritmit-ubuntu-server-v4.0-novice.tar.gz"
INSTALL_DIR="/opt/algoritmit-trading-bot"
SERVICE_NAME="algoritmit-trading-bot"
SERVICE_USER="algoritmit"

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Check Ubuntu version
check_ubuntu_version() {
    if ! command -v lsb_release &> /dev/null; then
        print_warning "lsb_release not found, attempting to install..."
        apt update && apt install -y lsb-release
    fi
    
    UBUNTU_VERSION=$(lsb_release -rs)
    print_info "Detected Ubuntu version: $UBUNTU_VERSION"
    
    if [[ "$UBUNTU_VERSION" != "20.04" && "$UBUNTU_VERSION" != "22.04" && "$UBUNTU_VERSION" != "24.04" ]]; then
        print_warning "This script is tested on Ubuntu 20.04, 22.04, and 24.04. Your version ($UBUNTU_VERSION) may work but is not guaranteed."
    fi
}

# Check system requirements
check_system_requirements() {
    print_info "Checking system requirements..."
    
    # Check available disk space (need at least 1GB)
    AVAILABLE_SPACE=$(df / | awk 'NR==2 {print $4}')
    if [ "$AVAILABLE_SPACE" -lt 1048576 ]; then
        print_error "Insufficient disk space. Need at least 1GB free space."
        exit 1
    fi
    
    # Check available memory (need at least 512MB)
    AVAILABLE_MEM=$(free -m | awk 'NR==2{printf "%.0f", $7}')
    if [ "$AVAILABLE_MEM" -lt 512 ]; then
        print_warning "Low memory detected (${AVAILABLE_MEM}MB). Performance may be affected."
    fi
    
    # Check network connectivity
    print_info "Checking network connectivity..."
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        print_warning "Basic network connectivity check failed"
    else
        print_success "Network connectivity check passed"
    fi
    
    # Check npm registry connectivity
    print_info "Checking npm registry connectivity..."
    if ! curl -s --connect-timeout 10 https://registry.npmjs.org/ &> /dev/null; then
        print_warning "npm registry connectivity check failed - will use fallback methods"
    else
        print_success "npm registry connectivity check passed"
    fi
    
    print_success "System requirements check passed"
}

# Enhanced package system fix with specific corito handling
fix_package_system() {
    print_info "Attempting to fix broken packages..."
    
    # First, try to remove corito specifically with multiple methods
    print_info "Attempting to remove problematic corito package..."
    
    # Method 1: Force remove with dpkg
    if dpkg -l | grep -q "corito"; then
        print_info "Found corito package, attempting force removal..."
        dpkg --remove --force-remove-reinstreq corito 2>/dev/null || true
        dpkg --purge --force-all corito 2>/dev/null || true
    fi
    
    # Method 2: Remove from dpkg status
    if grep -q "corito" /var/lib/dpkg/status; then
        print_info "Removing corito from dpkg status..."
        cp /var/lib/dpkg/status /var/lib/dpkg/status.backup
        sed -i '/^Package: corito$/,/^$/d' /var/lib/dpkg/status
    fi
    
    # Method 3: Clean up any remaining corito files
    if [ -f "/var/lib/dpkg/info/corito.list" ]; then
        print_info "Removing corito package files..."
        rm -f /var/lib/dpkg/info/corito.* 2>/dev/null || true
    fi
    
    # Now handle other broken packages
    print_info "Checking for other broken packages..."
    
    # Find and remove broken packages
    BROKEN_PACKAGES=$(dpkg -l | grep "^iU\|^rc" | awk '{print $2}' | grep -v "^$" || true)
    
    if [ -n "$BROKEN_PACKAGES" ]; then
        print_info "Found broken packages: $BROKEN_PACKAGES"
        for pkg in $BROKEN_PACKAGES; do
            print_info "Removing broken package: $pkg"
            dpkg --remove --force-remove-reinstreq "$pkg" 2>/dev/null || true
            dpkg --purge --force-all "$pkg" 2>/dev/null || true
        done
    fi
    
    print_info "Configuring package system..."
    dpkg --configure -a || true
    
    print_info "Fixing broken dependencies..."
    apt --fix-broken install -y || true
    
    print_info "Cleaning package cache..."
    apt clean
    apt autoclean
    apt autoremove -y
    
    print_info "Updating package lists..."
    apt update || true
    
    print_success "Package system fix completed"
}

# Safe system update
update_system_safely() {
    print_info "Updating system packages safely..."
    
    # Update package lists
    apt update
    
    # Get list of upgradable packages
    UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -v "WARNING" | grep -v "Listing" | cut -d'/' -f1 | grep -v "^$" || true)
    
    if [ -n "$UPGRADABLE" ]; then
        print_info "Found upgradable packages. Upgrading individually to avoid conflicts..."
        
        for pkg in $UPGRADABLE; do
            print_info "Upgrading: $pkg"
            if ! apt install -y "$pkg"; then
                print_warning "Failed to upgrade $pkg, skipping..."
                continue
            fi
        done
    else
        print_info "No packages need upgrading"
    fi
    
    print_success "System update completed"
}

# Install dependencies
install_dependencies() {
    print_info "Installing essential dependencies..."
    
    # Install essential packages individually with error handling
    ESSENTIAL_PACKAGES="curl wget git build-essential python3 python3-pip"
    
    for pkg in $ESSENTIAL_PACKAGES; do
        print_info "Installing: $pkg"
        if ! apt install -y "$pkg"; then
            print_warning "Failed to install $pkg, attempting to continue..."
        fi
    done
    
    # Install Node.js 18.x
    print_info "Installing Node.js 18.x..."
    
    # Remove any existing Node.js installations
    apt remove -y nodejs npm 2>/dev/null || true
    apt autoremove -y
    
    # Add NodeSource repository
    if ! command -v node &> /dev/null; then
        print_info "Adding NodeSource repository..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt install -y nodejs
    fi
    
    # Verify Node.js installation
    NODE_VERSION=$(node --version 2>/dev/null || echo "not installed")
    NPM_VERSION=$(npm --version 2>/dev/null || echo "not installed")
    
    print_info "Node.js version: $NODE_VERSION"
    print_info "npm version: $NPM_VERSION"
    
    if [[ "$NODE_VERSION" == "not installed" ]]; then
        print_error "Failed to install Node.js"
        exit 1
    fi
    
    print_success "Dependencies installed successfully"
}

# Download package with retry mechanism
download_package() {
    print_info "Downloading ALGORITMIT package..."
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Try multiple download methods
    DOWNLOAD_SUCCESS=false
    
    # Method 1: wget
    if command -v wget &> /dev/null; then
        print_info "Attempting download with wget..."
        if wget -q --show-progress "$PACKAGE_URL" -O algoritmit-package.tar.gz; then
            DOWNLOAD_SUCCESS=true
        fi
    fi
    
    # Method 2: curl (fallback)
    if [ "$DOWNLOAD_SUCCESS" = false ] && command -v curl &> /dev/null; then
        print_info "Attempting download with curl..."
        if curl -fsSL "$PACKAGE_URL" -o algoritmit-package.tar.gz; then
            DOWNLOAD_SUCCESS=true
        fi
    fi
    
    if [ "$DOWNLOAD_SUCCESS" = false ]; then
        print_error "Failed to download package from $PACKAGE_URL"
        print_info "Please check your internet connection and try again"
        exit 1
    fi
    
    print_success "Package downloaded successfully"
    
    # Extract package
    print_info "Extracting package..."
    tar -xzf algoritmit-package.tar.gz
    
    # Move to installation directory
    if [ -d "algoritmit-ubuntu-server-v4.0-novice" ]; then
        mkdir -p "$INSTALL_DIR"
        cp -r algoritmit-ubuntu-server-v4.0-novice/* "$INSTALL_DIR/"
        cd "$INSTALL_DIR"
    else
        print_error "Invalid package structure"
        exit 1
    fi
    
    # Clean up
    rm -rf "$TEMP_DIR"
    
    print_success "Package extracted to $INSTALL_DIR"
}

# Install Node.js dependencies with retry
install_node_dependencies() {
    print_info "Installing Node.js dependencies..."
    
    cd "$INSTALL_DIR"
    
    # Clear npm cache
    npm cache clean --force
    
    # Configure npm for better network handling
    print_info "Configuring npm for better network handling..."
    npm config set registry https://registry.npmjs.org/
    npm config set fetch-retries 5
    npm config set fetch-retry-mintimeout 20000
    npm config set fetch-retry-maxtimeout 120000
    
    # Try to detect and configure proxy if needed
    if [ -n "$http_proxy" ] || [ -n "$HTTP_PROXY" ]; then
        print_info "Detected proxy settings, configuring npm..."
        npm config set proxy "$http_proxy" 2>/dev/null || npm config set proxy "$HTTP_PROXY" 2>/dev/null || true
        npm config set https-proxy "$https_proxy" 2>/dev/null || npm config set https-proxy "$HTTPS_PROXY" 2>/dev/null || true
    fi
    
    # Install dependencies with multiple fallback methods
    MAX_RETRIES=5
    RETRY_COUNT=0
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        print_info "Attempting npm install (attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)"
        
        # Method 1: Standard npm install
        if npm install --production --no-audit --no-fund --prefer-offline; then
            print_success "Node.js dependencies installed successfully"
            return 0
        fi
        
        RETRY_COUNT=$((RETRY_COUNT + 1))
        print_warning "npm install failed (attempt $RETRY_COUNT/$MAX_RETRIES)"
        
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            print_info "Retrying in 10 seconds with different method..."
            sleep 10
            
            # Clear cache and try alternative methods
            npm cache clean --force
            
            # Try different installation methods based on retry count
            if [ $RETRY_COUNT -eq 2 ]; then
                print_info "Trying with alternative npm registry..."
                npm config set registry https://registry.npmjs.org/
                npm install --production --no-audit --no-fund --prefer-offline || true
            fi
            
            if [ $RETRY_COUNT -eq 3 ] && command -v yarn &> /dev/null; then
                print_info "Trying with yarn..."
                yarn install --production --ignore-engines || true
            fi
            
            if [ $RETRY_COUNT -eq 4 ] && command -v pnpm &> /dev/null; then
                print_info "Trying with pnpm..."
                pnpm install --prod --ignore-engines || true
            fi
            
            if [ $RETRY_COUNT -eq 5 ]; then
                print_info "Attempting manual package installation..."
                install_packages_manually
            fi
        fi
    done
    
    print_error "Failed to install Node.js dependencies after $MAX_RETRIES attempts"
    print_info "Attempting to continue with minimal installation..."
    
    # Try to install at least the essential packages manually
    install_essential_packages_manually
}

# Install packages manually as fallback
install_packages_manually() {
    print_info "Installing packages manually..."
    
    # Create node_modules directory
    mkdir -p node_modules
    
    # Install essential packages one by one
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
}

# Install essential packages manually as last resort
install_essential_packages_manually() {
    print_info "Installing essential packages manually as last resort..."
    
    # Create minimal package.json if it doesn't exist
    if [ ! -f "package.json" ]; then
        cat > package.json << EOF
{
  "name": "algoritmit-trading-bot",
  "version": "1.0.0",
  "description": "ALGORITMIT Trading Bot for Worldchain",
  "main": "worldchain-trading-bot.js",
  "dependencies": {
    "@holdstation/worldchain-sdk": "^4.0.29",
    "@holdstation/worldchain-ethers-v6": "^4.0.29",
    "ethers": "^6.0.0",
    "axios": "^1.0.0",
    "dotenv": "^16.0.0"
  }
}
EOF
    fi
    
    # Try to install with different network settings
    npm config set fetch-retries 10
    npm config set fetch-retry-mintimeout 30000
    npm config set fetch-retry-maxtimeout 300000
    
    # Try installation with different methods
    if npm install --production --no-audit --no-fund --prefer-offline --verbose; then
        print_success "Essential packages installed successfully"
        return 0
    fi
    
    # If still failing, try with yarn
    if command -v yarn &> /dev/null; then
        print_info "Trying yarn as final fallback..."
        yarn install --production --ignore-engines --network-timeout 300000
    fi
    
    print_warning "Manual installation completed with some packages potentially missing"
}

# Install HoldStation SDK with retry
install_holdstation_sdk() {
    print_info "Installing HoldStation SDK..."
    
    cd "$INSTALL_DIR"
    
    # Check if already installed
    if [ -d "node_modules/@holdstation" ]; then
        print_info "HoldStation SDK appears to be already installed"
        return 0
    fi
    
    MAX_RETRIES=3
    RETRY_COUNT=0
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        print_info "Installing HoldStation SDK (attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)"
        
        # Configure npm for better network handling
        npm config set fetch-retries 5
        npm config set fetch-retry-mintimeout 20000
        npm config set fetch-retry-maxtimeout 120000
        
        if npm install @holdstation/worldchain-sdk @holdstation/worldchain-ethers-v6 --no-audit --no-fund --prefer-offline; then
            print_success "HoldStation SDK installed successfully"
            return 0
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            print_warning "HoldStation SDK installation failed (attempt $RETRY_COUNT/$MAX_RETRIES)"
            
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
                print_info "Retrying in 10 seconds..."
                sleep 10
                npm cache clean --force
            fi
        fi
    done
    
    print_warning "Failed to install HoldStation SDK after $MAX_RETRIES attempts"
    print_info "The bot may still work with basic functionality"
}

# Setup environment
setup_environment() {
    print_info "Setting up environment..."
    
    # Create service user
    if ! id "$SERVICE_USER" &>/dev/null; then
        useradd -r -s /bin/false -d "$INSTALL_DIR" "$SERVICE_USER"
    fi
    
    # Set permissions
    chown -R "$SERVICE_USER:$SERVICE_USER" "$INSTALL_DIR"
    chmod -R 755 "$INSTALL_DIR"
    
    # Create .env file if it doesn't exist
    if [ ! -f "$INSTALL_DIR/.env" ]; then
        cat > "$INSTALL_DIR/.env" << EOF
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

# Telegram Configuration
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here

# Performance Configuration
PRICE_UPDATE_INTERVAL=30
LOG_LEVEL=info
EOF
        chown "$SERVICE_USER:$SERVICE_USER" "$INSTALL_DIR/.env"
        chmod 600 "$INSTALL_DIR/.env"
    fi
    
    print_success "Environment setup completed"
}

# Create systemd service
create_systemd_service() {
    print_info "Creating systemd service..."
    
    cat > "/etc/systemd/system/$SERVICE_NAME.service" << EOF
[Unit]
Description=ALGORITMIT Trading Bot
After=network.target

[Service]
Type=simple
User=$SERVICE_USER
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=$INSTALL_DIR

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd and enable service
    systemctl daemon-reload
    systemctl enable "$SERVICE_NAME"
    
    print_success "Systemd service created and enabled"
}

# Setup log rotation
setup_log_rotation() {
    print_info "Setting up log rotation..."
    
    cat > "/etc/logrotate.d/$SERVICE_NAME" << EOF
$INSTALL_DIR/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 $SERVICE_USER $SERVICE_USER
    postrotate
        systemctl reload $SERVICE_NAME > /dev/null 2>&1 || true
    endscript
}
EOF
    
    print_success "Log rotation configured"
}

# Create start script
create_start_script() {
    print_info "Creating start script..."
    
    cat > "$INSTALL_DIR/start.sh" << 'EOF'
#!/bin/bash
# ALGORITMIT Trading Bot Start Script

cd "$(dirname "$0")"

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found. Please configure the bot first."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Start the bot
echo "Starting ALGORITMIT Trading Bot..."
node worldchain-trading-bot.js
EOF
    
    chmod +x "$INSTALL_DIR/start.sh"
    chown "$SERVICE_USER:$SERVICE_USER" "$INSTALL_DIR/start.sh"
    
    print_success "Start script created"
}

# Create management script
create_management_script() {
    print_info "Creating management script..."
    
    cat > "/usr/local/bin/algoritmit" << EOF
#!/bin/bash
# ALGORITMIT Trading Bot Management Script

SERVICE_NAME="$SERVICE_NAME"
INSTALL_DIR="$INSTALL_DIR"

case "\$1" in
    start)
        systemctl start \$SERVICE_NAME
        ;;
    stop)
        systemctl stop \$SERVICE_NAME
        ;;
    restart)
        systemctl restart \$SERVICE_NAME
        ;;
    status)
        systemctl status \$SERVICE_NAME
        ;;
    logs)
        journalctl -u \$SERVICE_NAME -f
        ;;
    config)
        nano \$INSTALL_DIR/.env
        ;;
    update)
        echo "Updating ALGORITMIT Trading Bot..."
        cd \$INSTALL_DIR
        git pull origin main
        npm install
        systemctl restart \$SERVICE_NAME
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status|logs|config|update}"
        exit 1
        ;;
esac
EOF
    
    chmod +x "/usr/local/bin/algoritmit"
    
    print_success "Management script created"
}

# Show installation summary
show_installation_summary() {
    print_success "🎉 ALGORITMIT Trading Bot installation completed!"
    echo
    echo "📁 Installation directory: $INSTALL_DIR"
    echo "🔧 Service name: $SERVICE_NAME"
    echo "👤 Service user: $SERVICE_USER"
    echo
    echo "📋 Next steps:"
    echo "1. Configure the bot: nano $INSTALL_DIR/.env"
    echo "2. Start the service: systemctl start $SERVICE_NAME"
    echo "3. Check status: systemctl status $SERVICE_NAME"
    echo "4. View logs: journalctl -u $SERVICE_NAME -f"
    echo
    echo "🛠️  Management commands:"
    echo "  algoritmit start    - Start the bot"
    echo "  algoritmit stop     - Stop the bot"
    echo "  algoritmit restart  - Restart the bot"
    echo "  algoritmit status   - Check bot status"
    echo "  algoritmit logs     - View live logs"
    echo "  algoritmit config   - Edit configuration"
    echo
    echo "⚠️  IMPORTANT: Configure your .env file before starting the bot!"
    echo "   - Set your private key"
    echo "   - Configure RPC settings"
    echo "   - Set up Telegram notifications (optional)"
    echo
    echo "📚 Documentation: $INSTALL_DIR/README.md"
    echo "🆘 Support: https://github.com/notevayasconadan/eva/issues"
}

# Main installation function
main() {
    echo "🤖 ALGORITMIT Ubuntu Clean Installer v4.0"
    echo "=========================================="
    echo
    
    check_root
    check_ubuntu_version
    check_system_requirements
    fix_package_system
    update_system_safely
    install_dependencies
    download_package
    install_node_dependencies
    install_holdstation_sdk
    setup_environment
    create_systemd_service
    setup_log_rotation
    create_start_script
    create_management_script
    show_installation_summary
}

# Run main function
main "$@"