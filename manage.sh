#!/bin/bash
# ALGORITMIT Trading Bot Management Script

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
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
        print_status "Starting ALGORITMIT Trading Bot..."
        if [ ! -f ".env" ]; then
            print_error ".env file not found. Please configure the bot first."
            exit 1
        fi
        nohup node worldchain-trading-bot.js > /tmp/algoritmit.log 2>&1 &
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
        nohup node worldchain-trading-bot.js > /tmp/algoritmit.log 2>&1 &
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
        if [ -f "/tmp/algoritmit.log" ]; then
            print_status "Showing recent logs:"
            tail -f /tmp/algoritmit.log
        else
            print_warning "No log file found"
        fi
        ;;
    config)
        print_status "Opening configuration file..."
        if command -v nano &> /dev/null; then
            nano .env
        elif command -v vim &> /dev/null; then
            vim .env
        else
            echo "Please edit .env manually"
        fi
        ;;
    *)
        echo -e "${BLUE}ALGORITMIT Management Script${NC}"
        echo ""
        echo "Usage: $0 {start|stop|restart|status|logs|config}"
        echo ""
        echo "Commands:"
        echo "  start    - Start the bot"
        echo "  stop     - Stop the bot"
        echo "  restart  - Restart the bot"
        echo "  status   - Check bot status"
        echo "  logs     - View logs"
        echo "  config   - Edit configuration"
        exit 1
        ;;
esac