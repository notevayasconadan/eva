#!/bin/bash
# 🌙 ALGORITMIT MoonFixed Management Script

BOT_DIR="/workspace/algoritmit-moonfixed"
LOG_FILE="/tmp/algoritmit-moonfixed.log"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

case "$1" in
    start)
        print_status "Starting ALGORITMIT MoonFixed Trading Bot..."
        cd "$BOT_DIR"
        nohup ./start.sh > "$LOG_FILE" 2>&1 &
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
        cd "$BOT_DIR"
        nohup ./start.sh > "$LOG_FILE" 2>&1 &
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
        if [ -f "$LOG_FILE" ]; then
            print_status "Showing MoonFixed bot logs:"
            tail -f "$LOG_FILE"
        else
            print_warning "No log file found"
        fi
        ;;
    config)
        print_status "Opening MoonFixed configuration file..."
        if command -v nano &> /dev/null; then
            nano "$BOT_DIR/.env"
        elif command -v vim &> /dev/null; then
            vim "$BOT_DIR/.env"
        else
            echo "Please edit $BOT_DIR/.env manually"
        fi
        ;;
    test-rpc)
        print_status "Testing RPC connection..."
        cd "$BOT_DIR"
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
        cd "$BOT_DIR"
        git pull origin main 2>/dev/null || print_warning "Git not available"
        npm install
        print_status "MoonFixed update completed"
        ;;
    backup)
        print_status "Creating MoonFixed backup..."
        BACKUP_DIR="${BOT_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
        cp -r "$BOT_DIR" "$BACKUP_DIR"
        print_status "MoonFixed backup created: $BACKUP_DIR"
        ;;
    *)
        echo -e "${CYAN}🌙 ALGORITMIT MoonFixed Management Script${NC}"
        echo ""
        echo "Usage: $0 {start|stop|restart|status|logs|config|test-rpc|update|backup}"
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
