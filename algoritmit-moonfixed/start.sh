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
