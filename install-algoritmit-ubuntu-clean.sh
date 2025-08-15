#!/bin/bash

# 🤖 ALGORITMIT Ubuntu Clean Installer v4.0
# Enhanced installation script with package system fixes and error handling

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ASCII Art Banner
print_banner() {
    echo -e "${CYAN}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║  🤖 ALGORITMIT Ubuntu Clean Installer v4.0                  ║
    ║  🎯 Enhanced Installation with Package System Fixes          ║
    ║                                                              ║
    ║  Advanced AI-Powered Trading Bot for Worldchain             ║
    ║  Clean Installation Package for Ubuntu Servers              ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_header() {
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Check Ubuntu version
check_ubuntu_version() {
    print_header "Checking Ubuntu Version"
    
    if [[ ! -f /etc/os-release ]]; then
        print_error "This script is designed for Ubuntu systems only"
        exit 1
    fi
    
    source /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        print_error "This script is designed for Ubuntu systems only"
        exit 1
    fi
    
    print_status "Detected Ubuntu $VERSION_ID"
    
    # Check if version is supported
    if [[ "$VERSION_ID" != "20.04" && "$VERSION_ID" != "22.04" && "$VERSION_ID" != "24.04" ]]; then
        print_warning "Ubuntu $VERSION_ID detected. This script is tested with Ubuntu 20.04, 22.04, and 24.04"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check system requirements
check_system_requirements() {
    print_header "Checking System Requirements"
    
    # Check RAM
    total_ram=$(free -m | awk 'NR==2{printf "%.0f", $2/1024}')
    print_status "Total RAM: ${total_ram}GB"
    
    if [[ $total_ram -lt 2 ]]; then
        print_error "Minimum 2GB RAM required. Current: ${total_ram}GB"
        exit 1
    fi
    
    if [[ $total_ram -lt 4 ]]; then
        print_warning "Recommended 4GB RAM. Current: ${total_ram}GB"
    fi
    
    # Check disk space
    available_space=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
    print_status "Available disk space: ${available_space}GB"
    
    if [[ $available_space -lt 10 ]]; then
        print_error "Minimum 10GB free space required. Current: ${available_space}GB"
        exit 1
    fi
    
    # Check internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "No internet connection detected"
        exit 1
    fi
    
    print_success "System requirements met"
}

# Fix package system issues
fix_package_system() {
    print_header "Fixing Package System Issues"
    
    print_status "Checking for broken packages..."
    
    # Check for broken packages
    broken_packages=$(dpkg -l | grep -E "^iU|^rc" | awk '{print $2}' | grep -v "^$" || true)
    
    if [[ -n "$broken_packages" ]]; then
        print_warning "Found broken packages: $broken_packages"
        print_status "Attempting to fix broken packages..."
        
        # Remove broken packages
        for package in $broken_packages; do
            print_status "Removing broken package: $package"
            dpkg --remove --force-remove-reinstreq "$package" 2>/dev/null || true
            dpkg --purge --force-all "$package" 2>/dev/null || true
        done
    fi
    
    # Fix package system
    print_status "Configuring package system..."
    dpkg --configure -a || true
    
    print_status "Fixing broken dependencies..."
    apt --fix-broken install -y || true
    
    print_status "Cleaning package cache..."
    apt clean
    apt autoclean
    apt autoremove -y
    
    print_status "Updating package lists..."
    apt update
    
    print_success "Package system fixed"
}

# Update system packages safely
update_system_safely() {
    print_header "Updating System Packages Safely"
    
    print_status "Updating package list..."
    apt update
    
    print_status "Checking for available upgrades..."
    upgradable_packages=$(apt list --upgradable 2>/dev/null | grep -v "WARNING" | grep -v "Listing" | wc -l)
    
    if [[ $upgradable_packages -gt 0 ]]; then
        print_status "Found $upgradable_packages packages to upgrade"
        
        # Upgrade packages one by one to avoid issues
        apt list --upgradable 2>/dev/null | grep -v "WARNING" | grep -v "Listing" | cut -d'/' -f1 | while read package; do
            if [[ -n "$package" ]]; then
                print_status "Upgrading: $package"
                apt install -y "$package" || {
                    print_warning "Failed to upgrade $package, skipping..."
                    continue
                }
            fi
        done
    else
        print_status "No packages to upgrade"
    fi
    
    print_success "System updated successfully"
}

# Install essential dependencies
install_dependencies() {
    print_header "Installing Essential Dependencies"
    
    print_status "Installing essential packages..."
    
    # Install packages one by one to avoid issues
    packages=(
        "curl"
        "wget"
        "git"
        "build-essential"
        "python3"
        "python3-pip"
        "software-properties-common"
        "apt-transport-https"
        "ca-certificates"
        "gnupg"
        "lsb-release"
        "htop"
        "nano"
        "vim"
        "screen"
        "tmux"
    )
    
    for package in "${packages[@]}"; do
        print_status "Installing: $package"
        apt install -y "$package" || {
            print_warning "Failed to install $package, continuing..."
            continue
        }
    done
    
    print_status "Installing Node.js 18.x..."
    
    # Remove old Node.js if exists
    apt remove -y nodejs npm 2>/dev/null || true
    
    # Install Node.js 18
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs
    
    # Verify Node.js installation
    node_version=$(node --version)
    npm_version=$(npm --version)
    print_status "Node.js version: $node_version"
    print_status "npm version: $npm_version"
    
    print_success "Dependencies installed successfully"
}

# Create installation directory
create_installation_directory() {
    print_header "Creating Installation Directory"
    
    INSTALL_DIR="/opt/algoritmit"
    
    print_status "Creating installation directory: $INSTALL_DIR"
    mkdir -p $INSTALL_DIR
    cd $INSTALL_DIR
    
    print_success "Installation directory created"
}

# Download and extract the package
download_package() {
    print_header "Downloading ALGORITMIT Package"
    
    PACKAGE_URL="https://github.com/notevayasconadan/eva/raw/cursor/check-repository-branches-for-latest-code-05c1/releases/algoritmit-ubuntu-server-v4.0-novice.tar.gz"
    PACKAGE_NAME="algoritmit-ubuntu-server-v4.0-novice.tar.gz"
    
    print_status "Downloading package from GitHub..."
    
    # Try multiple download methods
    if command -v wget &> /dev/null; then
        wget -O $PACKAGE_NAME $PACKAGE_URL || {
            print_warning "wget failed, trying curl..."
            curl -L -o $PACKAGE_NAME $PACKAGE_URL || {
                print_error "Failed to download package"
                exit 1
            }
        }
    elif command -v curl &> /dev/null; then
        curl -L -o $PACKAGE_NAME $PACKAGE_URL || {
            print_error "Failed to download package"
            exit 1
        }
    else
        print_error "Neither wget nor curl is available"
        exit 1
    fi
    
    if [[ ! -f $PACKAGE_NAME ]]; then
        print_error "Failed to download package"
        exit 1
    fi
    
    print_status "Extracting package..."
    tar -xzf $PACKAGE_NAME
    
    if [[ ! -d "algoritmit-ubuntu-server-v4.0-novice" ]]; then
        print_error "Failed to extract package"
        exit 1
    fi
    
    cd algoritmit-ubuntu-server-v4.0-novice
    
    print_success "Package downloaded and extracted successfully"
}

# Install Node.js dependencies
install_node_dependencies() {
    print_header "Installing Node.js Dependencies"
    
    print_status "Installing npm packages..."
    
    # Clear npm cache first
    npm cache clean --force
    
    # Install dependencies with retry mechanism
    max_retries=3
    for ((i=1; i<=max_retries; i++)); do
        print_status "Attempt $i of $max_retries to install npm packages..."
        if npm install --production; then
            break
        else
            if [[ $i -eq $max_retries ]]; then
                print_error "Failed to install npm dependencies after $max_retries attempts"
                exit 1
            fi
            print_warning "npm install failed, retrying..."
            sleep 2
        fi
    done
    
    print_success "Node.js dependencies installed successfully"
}

# Install HoldStation SDK
install_holdstation_sdk() {
    print_header "Installing HoldStation SDK"
    
    print_status "Installing HoldStation SDK..."
    
    # Install HoldStation SDK with retry mechanism
    max_retries=3
    for ((i=1; i<=max_retries; i++)); do
        print_status "Attempt $i of $max_retries to install HoldStation SDK..."
        if npm install @holdstation/worldchain-sdk@^4.0.29 && npm install @holdstation/worldchain-ethers-v6@^4.0.29; then
            break
        else
            if [[ $i -eq $max_retries ]]; then
                print_error "Failed to install HoldStation SDK after $max_retries attempts"
                exit 1
            fi
            print_warning "HoldStation SDK install failed, retrying..."
            sleep 2
        fi
    done
    
    print_success "HoldStation SDK installed successfully"
}

# Setup environment configuration
setup_environment() {
    print_header "Setting Up Environment Configuration"
    
    print_status "Creating environment configuration..."
    
    # Create .env.example if it doesn't exist
    if [[ ! -f .env.example ]]; then
        cat > .env.example << 'EOF'
# ALGORITMIT Ubuntu Server Configuration
# Copy this file to .env and edit with your settings

# Wallet Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key

# ALGORITMIT ML Settings
ML_CONFIDENCE_THRESHOLD=75
ML_MAX_POSITION_SIZE=0.01
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false

# Telegram Notifications (Optional)
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Logging Configuration
LOG_LEVEL=info
LOG_TO_FILE=true
LOG_FILE_PATH=./logs/bot.log

# Performance Settings
PRICE_CHECK_INTERVAL=3
MAX_CONCURRENT_TRADES=3
GAS_LIMIT_BUFFER=1.2

# Safety Settings
EMERGENCY_STOP=false
MAX_DAILY_LOSS=0.5
STOP_LOSS_PERCENTAGE=10
EOF
    fi
    
    # Copy .env.example to .env if .env doesn't exist
    if [[ ! -f .env ]]; then
        cp .env.example .env
        print_status "Environment file created: .env"
        print_warning "Please edit .env file with your configuration before starting the bot"
    else
        print_status "Environment file already exists: .env"
    fi
    
    # Create logs directory
    mkdir -p logs
    
    print_success "Environment configuration setup complete"
}

# Create systemd service
create_systemd_service() {
    print_header "Creating Systemd Service"
    
    SERVICE_FILE="/etc/systemd/system/algoritmit.service"
    
    print_status "Creating systemd service file..."
    
    cat > $SERVICE_FILE << EOF
[Unit]
Description=ALGORITMIT Trading Bot
After=network.target
Wants=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=algoritmit
Environment=NODE_ENV=production
Environment=HOME=/root

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/algoritmit

# Resource limits
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd
    systemctl daemon-reload
    
    print_success "Systemd service created: $SERVICE_FILE"
}

# Setup log rotation
setup_log_rotation() {
    print_header "Setting Up Log Rotation"
    
    LOGROTATE_FILE="/etc/logrotate.d/algoritmit"
    
    print_status "Creating log rotation configuration..."
    
    cat > $LOGROTATE_FILE << EOF
/opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 root root
    postrotate
        systemctl reload algoritmit > /dev/null 2>&1 || true
    endscript
}
EOF
    
    print_success "Log rotation configured"
}

# Create start script
create_start_script() {
    print_header "Creating Start Script"
    
    print_status "Creating start script..."
    
    cat > start.sh << 'EOF'
#!/bin/bash

# ALGORITMIT Start Script
# This script starts the trading bot with proper environment

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🤖 Starting ALGORITMIT Trading Bot...${NC}"

# Check if .env exists
if [[ ! -f .env ]]; then
    echo -e "${RED}❌ Error: .env file not found${NC}"
    echo -e "${YELLOW}💡 Please copy .env.example to .env and configure your settings${NC}"
    exit 1
fi

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Error: Node.js not found${NC}"
    exit 1
fi

# Create logs directory
mkdir -p logs

# Start the bot
echo -e "${GREEN}🚀 Starting bot...${NC}"
node worldchain-trading-bot.js
EOF
    
    chmod +x start.sh
    
    print_success "Start script created: start.sh"
}

# Create management script
create_management_script() {
    print_header "Creating Management Script"
    
    print_status "Creating management script..."
    
    cat > manage-algoritmit.sh << 'EOF'
#!/bin/bash

# ALGORITMIT Management Script
# This script provides easy management of the ALGORITMIT service

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

SERVICE_NAME="algoritmit"
INSTALL_DIR="/opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice"

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    echo -e "${BLUE}ALGORITMIT Management Script${NC}"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     - Start the ALGORITMIT service"
    echo "  stop      - Stop the ALGORITMIT service"
    echo "  restart   - Restart the ALGORITMIT service"
    echo "  status    - Show service status"
    echo "  logs      - Show service logs"
    echo "  config    - Edit configuration file"
    echo "  update    - Update ALGORITMIT to latest version"
    echo "  uninstall - Uninstall ALGORITMIT"
    echo "  help      - Show this help message"
    echo ""
}

case "$1" in
    start)
        print_status "Starting ALGORITMIT service..."
        systemctl start $SERVICE_NAME
        systemctl enable $SERVICE_NAME
        print_status "Service started and enabled"
        ;;
    stop)
        print_status "Stopping ALGORITMIT service..."
        systemctl stop $SERVICE_NAME
        systemctl disable $SERVICE_NAME
        print_status "Service stopped and disabled"
        ;;
    restart)
        print_status "Restarting ALGORITMIT service..."
        systemctl restart $SERVICE_NAME
        print_status "Service restarted"
        ;;
    status)
        systemctl status $SERVICE_NAME
        ;;
    logs)
        journalctl -u $SERVICE_NAME -f
        ;;
    config)
        if [[ -f "$INSTALL_DIR/.env" ]]; then
            nano "$INSTALL_DIR/.env"
        else
            print_error "Configuration file not found"
        fi
        ;;
    update)
        print_status "Updating ALGORITMIT..."
        systemctl stop $SERVICE_NAME
        cd $INSTALL_DIR
        git pull origin main
        npm install
        systemctl start $SERVICE_NAME
        print_status "Update completed"
        ;;
    uninstall)
        print_warning "This will completely remove ALGORITMIT"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            systemctl stop $SERVICE_NAME
            systemctl disable $SERVICE_NAME
            rm -f /etc/systemd/system/$SERVICE_NAME.service
            rm -f /etc/logrotate.d/$SERVICE_NAME
            systemctl daemon-reload
            rm -rf /opt/algoritmit
            print_status "ALGORITMIT uninstalled"
        fi
        ;;
    help|*)
        show_help
        ;;
esac
EOF
    
    chmod +x manage-algoritmit.sh
    
    # Create symlink for easy access
    ln -sf $PWD/manage-algoritmit.sh /usr/local/bin/algoritmit
    
    print_success "Management script created: manage-algoritmit.sh"
    print_status "You can now use: algoritmit [command] from anywhere"
}

# Display installation summary
show_installation_summary() {
    print_header "Installation Summary"
    
    echo -e "${GREEN}✅ ALGORITMIT Ubuntu Clean Package v4.0 installed successfully!${NC}"
    echo ""
    echo -e "${WHITE}📁 Installation Directory:${NC} /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice"
    echo -e "${WHITE}🔧 Service Name:${NC} algoritmit"
    echo -e "${WHITE}📝 Configuration File:${NC} /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/.env"
    echo -e "${WHITE}📊 Logs Directory:${NC} /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/logs"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Edit configuration: sudo nano /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/.env"
    echo "2. Start the service: sudo systemctl start algoritmit"
    echo "3. Enable auto-start: sudo systemctl enable algoritmit"
    echo "4. Check status: sudo systemctl status algoritmit"
    echo "5. View logs: sudo journalctl -u algoritmit -f"
    echo ""
    echo -e "${BLUE}🛠️  Management Commands:${NC}"
    echo "• Start/Stop: sudo algoritmit start|stop"
    echo "• Status: sudo algoritmit status"
    echo "• Logs: sudo algoritmit logs"
    echo "• Config: sudo algoritmit config"
    echo "• Update: sudo algoritmit update"
    echo ""
    echo -e "${PURPLE}📚 Documentation:${NC}"
    echo "• README: /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/README.md"
    echo "• Quick Start: /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/QUICK_START.md"
    echo ""
    echo -e "${CYAN}🎯 For Novice Traders:${NC}"
    echo "• Start with LEARNING_MODE=true in .env"
    echo "• Use small position sizes (0.01-0.1 WLD)"
    echo "• Monitor performance for 24-48 hours"
    echo "• Enable auto-trading only after learning period"
    echo ""
    echo -e "${GREEN}🚀 Happy Trading!${NC}"
}

# Main installation function
main() {
    print_banner
    
    print_status "Starting ALGORITMIT Ubuntu Clean Installation..."
    echo ""
    
    # Check requirements
    check_root
    check_ubuntu_version
    check_system_requirements
    
    # Fix package system issues first
    fix_package_system
    
    # Installation steps
    update_system_safely
    install_dependencies
    create_installation_directory
    download_package
    install_node_dependencies
    install_holdstation_sdk
    setup_environment
    create_systemd_service
    setup_log_rotation
    create_start_script
    create_management_script
    
    # Show summary
    show_installation_summary
}

# Run main function
main "$@"