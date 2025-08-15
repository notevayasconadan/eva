#!/bin/bash
# 🔧 ALGORITMIT RPC Configuration Fix
# Fixes RPC endpoints for Worldchain connectivity

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Find .env file
find_env_file() {
    if [ -f ".env" ]; then
        echo ".env"
    elif [ -f "algoritmit-bot/.env" ]; then
        echo "algoritmit-bot/.env"
    elif [ -f "/opt/algoritmit-trading-bot/.env" ]; then
        echo "/opt/algoritmit-trading-bot/.env"
    else
        print_error "No .env file found. Please run the installer first."
        exit 1
    fi
}

# Test RPC endpoints
test_rpc_endpoint() {
    local url="$1"
    local name="$2"
    
    print_info "Testing $name: $url"
    
    if curl -s -X POST -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
        "$url" > /dev/null 2>&1; then
        print_success "✅ $name is working"
        return 0
    else
        print_warning "❌ $name is not responding"
        return 1
    fi
}

# Fix RPC configuration
fix_rpc_config() {
    local env_file="$1"
    
    print_info "Fixing RPC configuration in $env_file"
    
    # Backup original file
    cp "$env_file" "${env_file}.backup.$(date +%Y%m%d_%H%M%S)"
    print_success "Backup created: ${env_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Test current RPC endpoints
    print_info "Testing current RPC endpoints..."
    
    # Get current RPC URL
    CURRENT_RPC=$(grep "^RPC_URL=" "$env_file" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
    
    if [ -n "$CURRENT_RPC" ]; then
        print_info "Current RPC URL: $CURRENT_RPC"
        test_rpc_endpoint "$CURRENT_RPC" "Current RPC"
    fi
    
    # Test working Worldchain RPC endpoints
    print_info "Testing working Worldchain RPC endpoints..."
    
    WORKING_RPC=""
    
    # Test Alchemy Public (usually works)
    if test_rpc_endpoint "https://worldchain-mainnet.g.alchemy.com/public" "Alchemy Public"; then
        WORKING_RPC="https://worldchain-mainnet.g.alchemy.com/public"
    fi
    
    # Test DRPC Public
    if [ -z "$WORKING_RPC" ] && test_rpc_endpoint "https://worldchain.drpc.org" "DRPC Public"; then
        WORKING_RPC="https://worldchain.drpc.org"
    fi
    
    # Test QuickNode
    if [ -z "$WORKING_RPC" ] && test_rpc_endpoint "https://worldchain.quicknode.com" "QuickNode"; then
        WORKING_RPC="https://worldchain.quicknode.com"
    fi
    
    # Test alternative endpoints
    if [ -z "$WORKING_RPC" ]; then
        ALTERNATIVE_ENDPOINTS=(
            "https://rpc.worldchain.org"
            "https://worldchain-rpc.publicnode.com"
            "https://worldchain.drpc.org"
            "https://worldchain-mainnet.g.alchemy.com/public"
        )
        
        for endpoint in "${ALTERNATIVE_ENDPOINTS[@]}"; do
            if test_rpc_endpoint "$endpoint" "Alternative"; then
                WORKING_RPC="$endpoint"
                break
            fi
        done
    fi
    
    if [ -z "$WORKING_RPC" ]; then
        print_warning "No working RPC endpoints found. Using fallback configuration."
        WORKING_RPC="https://worldchain-mainnet.g.alchemy.com/public"
    fi
    
    # Update .env file with working RPC
    print_info "Updating RPC configuration..."
    
    # Create new .env content
    cat > "$env_file" << EOF
# ALGORITMIT Trading Bot Configuration
# Updated with working RPC endpoints on $(date)

# Wallet Configuration
PRIVATE_KEY=your_private_key_here
WALLET_ADDRESS=your_wallet_address_here

# RPC Configuration (Updated)
RPC_URL=$WORKING_RPC
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

# RPC Fallback Configuration
RPC_FALLBACK_URLS=(
    "https://worldchain-mainnet.g.alchemy.com/public"
    "https://worldchain.drpc.org"
    "https://rpc.worldchain.org"
    "https://worldchain-rpc.publicnode.com"
)
EOF
    
    print_success "RPC configuration updated successfully!"
    print_info "Working RPC URL: $WORKING_RPC"
    
    # Show configuration summary
    echo
    print_info "Configuration Summary:"
    echo "  📁 Config file: $env_file"
    echo "  🌐 RPC URL: $WORKING_RPC"
    echo "  🔗 Chain ID: 12345"
    echo "  📊 Trading: Disabled (Learning Mode)"
    echo
    print_warning "⚠️  IMPORTANT: Update your private key and wallet address in the .env file!"
}

# Main function
main() {
    echo "🔧 ALGORITMIT RPC Configuration Fix"
    echo "===================================="
    echo
    
    # Find .env file
    ENV_FILE=$(find_env_file)
    print_info "Found configuration file: $ENV_FILE"
    
    # Fix RPC configuration
    fix_rpc_config "$ENV_FILE"
    
    echo
    print_success "🎉 RPC configuration fix completed!"
    echo
    echo "📋 Next steps:"
    echo "1. Edit your private key: nano $ENV_FILE"
    echo "2. Restart the bot: ./manage.sh restart"
    echo "3. Check status: ./manage.sh status"
    echo
    echo "🛠️  If you still have issues:"
    echo "   - Check logs: ./manage.sh logs"
    echo "   - Try different RPC endpoints manually"
    echo "   - Contact support for additional help"
}

# Run main function
main "$@"