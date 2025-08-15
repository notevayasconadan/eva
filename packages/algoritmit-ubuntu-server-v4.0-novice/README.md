# 🤖 ALGORITMIT Ubuntu Server Package v4.0 - Novice Trader Edition

**Complete Ubuntu Server Installation Package for Novice Traders with Root Access**

## 🎯 What This Package Contains

This package is specifically designed for **novice traders** who want to run the ALGORITMIT trading bot on an **Ubuntu server with root access**. It includes everything you need for a complete installation with step-by-step instructions.

### 📦 Package Contents
- ✅ **Complete ALGORITMIT v4.0 Trading Bot** (Latest version)
- ✅ **Ubuntu Server Optimized Installation Scripts**
- ✅ **Root Access Installation Methods**
- ✅ **Novice-Friendly Setup Wizards**
- ✅ **Comprehensive Documentation**
- ✅ **Safety Features & Learning Mode**
- ✅ **Telegram Notifications Setup**
- ✅ **Automated Dependency Installation**

## 🚀 Quick Start (One-Line Installation)

### For Root Users (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-root.sh | sudo bash
```

### For Non-Root Users (with sudo)
```bash
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-novice.sh | bash
```

## 📋 Prerequisites

### System Requirements
- **Operating System**: Ubuntu 20.04 LTS or Ubuntu 22.04 LTS
- **RAM**: Minimum 2GB (4GB recommended)
- **Storage**: Minimum 10GB free space
- **Network**: Stable internet connection
- **Access**: Root access or sudo privileges

### Required Accounts
- **Worldcoin Wallet**: For trading (with some WLD tokens)
- **Alchemy Account**: For RPC access (free tier available)
- **Telegram Bot**: For notifications (optional)

## 🔧 Installation Methods

### Method 1: Automated Root Installation (Easiest)
```bash
# Download and run the root installer
wget https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-root.sh
chmod +x install-algoritmit-ubuntu-root.sh
sudo ./install-algoritmit-ubuntu-root.sh
```

### Method 2: Interactive Novice Installer
```bash
# Download and run the novice installer
wget https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-novice.sh
chmod +x install-algoritmit-ubuntu-novice.sh
./install-algoritmit-ubuntu-novice.sh
```

### Method 3: Manual Installation
```bash
# Clone the repository
git clone https://github.com/romerodevv/psgho.git
cd psgho

# Run the manual installer
sudo ./manual-install-ubuntu.sh
```

## 📖 Detailed Installation Guide

### Step 1: System Preparation
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential dependencies
sudo apt install -y curl wget git build-essential python3 python3-pip nodejs npm

# Install Node.js 18+ (if not already installed)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Step 2: Download and Extract Package
```bash
# Create installation directory
sudo mkdir -p /opt/algoritmit
cd /opt/algoritmit

# Download the package
wget https://github.com/romerodevv/psgho/releases/download/v4.0/algoritmit-ubuntu-server-v4.0-novice.tar.gz

# Extract the package
sudo tar -xzf algoritmit-ubuntu-server-v4.0-novice.tar.gz
cd algoritmit-ubuntu-server-v4.0-novice
```

### Step 3: Install Dependencies
```bash
# Install Node.js dependencies
sudo npm install

# Install HoldStation SDK
sudo ./install-holdstation-sdk.sh

# Install system dependencies
sudo ./install-system-dependencies.sh
```

### Step 4: Configure Environment
```bash
# Copy environment template
sudo cp .env.example .env

# Edit configuration (use nano or vim)
sudo nano .env
```

### Step 5: Setup Configuration
Edit the `.env` file with your settings:
```env
# Wallet Configuration
PRIVATE_KEY_1=your_private_key_here
WALLET_NAME_1=Main Trading Wallet

# RPC Configuration
WORLDCHAIN_RPC_URL=https://worldchain-mainnet.g.alchemy.com/public
ALCHEMY_API_KEY=your_alchemy_api_key

# ALGORITMIT Settings
ML_CONFIDENCE_THRESHOLD=75
ML_MAX_POSITION_SIZE=0.1
ML_LEARNING_MODE=true
ML_AUTO_TRADING=false

# Telegram Notifications (Optional)
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id
```

### Step 6: Start the Bot
```bash
# Start the trading bot
sudo node worldchain-trading-bot.js

# Or use the start script
sudo ./start.sh
```

## 🛡️ Safety Features for Novice Traders

### Learning Mode (Recommended for Beginners)
- **24+ Hour Learning Period**: Bot learns market patterns without trading
- **Paper Trading**: Test strategies without real money
- **Confidence Thresholds**: Only trade when AI is highly confident
- **Position Limits**: Maximum trade size protection

### Risk Management
- **Stop Loss Protection**: Automatic loss prevention
- **Position Sizing**: Configurable maximum position sizes
- **Manual Override**: Disable auto-trading anytime
- **Emergency Stop**: Immediate trading halt

## 📱 Telegram Notifications Setup

### Step 1: Create Telegram Bot
1. Message `@BotFather` on Telegram
2. Send `/newbot` command
3. Follow instructions to create your bot
4. Copy the bot token

### Step 2: Get Chat ID
1. Message your bot
2. Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
3. Find your `chat_id` in the response

### Step 3: Configure Notifications
```bash
# Edit the .env file
sudo nano .env

# Add your Telegram settings
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here
```

## 🔄 Running as a Service

### Create Systemd Service
```bash
# Create service file
sudo nano /etc/systemd/system/algoritmit.service
```

Add the following content:
```ini
[Unit]
Description=ALGORITMIT Trading Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice
ExecStart=/usr/bin/node worldchain-trading-bot.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

### Enable and Start Service
```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable algoritmit

# Start service
sudo systemctl start algoritmit

# Check status
sudo systemctl status algoritmit
```

## 📊 Monitoring and Logs

### View Logs
```bash
# View service logs
sudo journalctl -u algoritmit -f

# View application logs
sudo tail -f /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/logs/bot.log
```

### Check Status
```bash
# Check service status
sudo systemctl status algoritmit

# Check if bot is running
sudo ps aux | grep worldchain-trading-bot
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Node.js Version Issues
```bash
# Check Node.js version
node --version

# If version is < 16, install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### 2. Permission Issues
```bash
# Fix permissions
sudo chown -R root:root /opt/algoritmit
sudo chmod -R 755 /opt/algoritmit
```

#### 3. Network Issues
```bash
# Check internet connection
ping -c 3 google.com

# Check if ports are open
sudo netstat -tlnp | grep :3000
```

#### 4. Dependency Issues
```bash
# Reinstall dependencies
sudo rm -rf node_modules package-lock.json
sudo npm install
```

### Getting Help
- **Documentation**: Check the `/docs` folder
- **Logs**: Review logs in `/logs` directory
- **Community**: Join our Telegram group
- **Issues**: Report on GitHub

## 📈 Performance Optimization

### System Optimization
```bash
# Increase file descriptors
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

# Optimize network settings
echo "net.core.rmem_max = 16777216" | sudo tee -a /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Bot Optimization
- **Price Check Interval**: Set to 3-5 seconds for optimal performance
- **Logging Level**: Reduce verbosity for better performance
- **Memory Usage**: Monitor with `htop` or `top`

## 🔄 Updates and Maintenance

### Update the Bot
```bash
# Stop the service
sudo systemctl stop algoritmit

# Backup current configuration
sudo cp /opt/algoritmit/algoritmit-ubuntu-server-v4.0-novice/.env /opt/algoritmit/.env.backup

# Download latest version
cd /opt/algoritmit
sudo wget https://github.com/romerodevv/psgho/releases/download/v4.0/algoritmit-ubuntu-server-v4.0-novice.tar.gz

# Extract and install
sudo tar -xzf algoritmit-ubuntu-server-v4.0-novice.tar.gz
sudo cp .env.backup algoritmit-ubuntu-server-v4.0-novice/.env

# Restart service
sudo systemctl start algoritmit
```

### Regular Maintenance
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Clean npm cache
sudo npm cache clean --force

# Check disk space
df -h

# Monitor system resources
htop
```

## 📞 Support and Resources

### Documentation
- **Quick Start Guide**: `QUICK_START.md`
- **Installation Guide**: `INSTALLATION_GUIDE.md`
- **Configuration Guide**: `CONFIGURATION_GUIDE.md`
- **Troubleshooting**: `TROUBLESHOOTING.md`

### Community
- **Telegram Group**: [ALGORITMIT Community](https://t.me/algoritmit_community)
- **Discord Server**: [ALGORITMIT Discord](https://discord.gg/algoritmit)
- **GitHub Issues**: [Report Issues](https://github.com/romerodevv/psgho/issues)

### Contact
- **Email**: support@algoritmit.com
- **Telegram**: @algoritmit_support
- **Website**: https://algoritmit.com

## 📄 License

This software is licensed under the MIT License. See the `LICENSE` file for details.

## ⚠️ Disclaimer

Trading cryptocurrencies involves significant risk. This software is for educational and entertainment purposes only. Never invest more than you can afford to lose. The developers are not responsible for any financial losses.

---

**Happy Trading! 🚀**

*ALGORITMIT Ubuntu Server Package v4.0 - Novice Trader Edition*