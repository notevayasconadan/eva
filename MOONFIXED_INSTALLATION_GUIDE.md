# 🌙 ALGORITMIT MoonFixed Installation Guide

## 🎯 Complete Package with Fixed RPC Configuration

This guide provides step-by-step instructions for installing the **ALGORITMIT MoonFixed** trading bot with **correct RPC configuration** and **comprehensive error handling**.

## 📋 Prerequisites

- Ubuntu/Debian server (or compatible Linux distribution)
- Root access or sudo privileges
- Internet connection
- At least 1GB free disk space
- At least 1GB RAM (2GB recommended)

## 🚀 Quick Installation

### Option 1: One-Line Installer (Recommended)

```bash
# Download and run the MoonFixed installer
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/moonfixed-one-line-install.sh | bash
```

### Option 2: Manual Installation

```bash
# Download the installer
wget https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/moonfixed-one-line-install.sh

# Make executable and run
chmod +x moonfixed-one-line-install.sh
./moonfixed-one-line-install.sh
```

### Option 3: Alternative Installer

```bash
# Download and run the alternative installer
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/install-algoritmit-moonfixed.sh | bash
```

## 🔧 Post-Installation Configuration

### 1. Fix RPC Configuration (If Needed)

If you encounter RPC connection issues, run the RPC fix script:

```bash
# Download and run the RPC fix script
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/fix-moonfixed-rpc.sh | bash
```

### 2. Configure Your Wallet

Edit the configuration file:

```bash
nano algoritmit-moonfixed/.env
```

**Important settings to configure:**
- `PRIVATE_KEY=your_private_key_here` - Your wallet's private key
- `WALLET_ADDRESS=your_wallet_address_here` - Your wallet's address
- `TELEGRAM_BOT_TOKEN=your_bot_token_here` - Telegram bot token (optional)
- `TELEGRAM_CHAT_ID=your_chat_id_here` - Telegram chat ID (optional)

### 3. Test RPC Connection

```bash
cd algoritmit-moonfixed
./manage.sh test-rpc
```

You should see:
```
✅ RPC Connection: OK
🔗 Chain ID: 480
📦 Block: [current block number]
```

## 🛠️ Management Commands

### Start the Bot
```bash
./manage.sh start
```

### Stop the Bot
```bash
./manage.sh stop
```

### Restart the Bot
```bash
./manage.sh restart
```

### Check Status
```bash
./manage.sh status
```

### View Logs
```bash
./manage.sh logs
```

### Edit Configuration
```bash
./manage.sh config
```

### Test RPC Connection
```bash
./manage.sh test-rpc
```

### Create Backup
```bash
./manage.sh backup
```

## 🌙 MoonFixed Features

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

### RPC Connection Issues

1. **Test RPC connection:**
   ```bash
   ./manage.sh test-rpc
   ```

2. **Run RPC fix script:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/fix-moonfixed-rpc.sh | bash
   ```

3. **Manual RPC test:**
   ```bash
   cd algoritmit-moonfixed
   node test-rpc-moonfixed.js
   ```

### Bot Won't Start

1. **Check Node.js installation:**
   ```bash
   node --version
   ```

2. **Check dependencies:**
   ```bash
   ls node_modules
   ```

3. **Reinstall dependencies:**
   ```bash
   npm install
   ```

4. **Check configuration:**
   ```bash
   ./manage.sh config
   ```

### Dependencies Issues

1. **Clear npm cache:**
   ```bash
   npm cache clean --force
   ```

2. **Reinstall dependencies:**
   ```bash
   npm install
   ```

3. **Check package.json:**
   ```bash
   cat package.json
   ```

## 📁 File Structure

After installation, your directory structure will be:

```
algoritmit-moonfixed/
├── .env                          # Configuration file
├── start.sh                      # Start script
├── manage.sh                     # Management script
├── README.md                     # Documentation
├── worldchain-trading-bot.js     # Main bot file
├── trading-strategy.js           # Trading strategy
├── strategy-builder.js           # Strategy builder
├── price-database.js             # Price database
├── algoritmit-strategy.js        # ALGORITMIT strategy
├── telegram-notifications.js     # Telegram notifications
├── token-discovery.js            # Token discovery
├── trading-engine.js             # Trading engine
├── sinclave-enhanced-engine.js   # Enhanced engine
├── sinclave.js                   # Sinclave engine
├── package.json                  # Dependencies
├── node_modules/                 # Installed packages
└── logs/                         # Log files
```

## 🔒 Security

- **Never share your private key**
- **Use strong passwords**
- **Keep your .env file secure**
- **Regular backups:** `./manage.sh backup`

## 📊 Monitoring

- **Status:** `./manage.sh status`
- **Logs:** `./manage.sh logs`
- **Configuration:** `./manage.sh config`
- **RPC Test:** `./manage.sh test-rpc`

## 🆘 Support

For help and support:
- **GitHub Issues:** https://github.com/notevayasconadan/eva/issues
- **Documentation:** `algoritmit-moonfixed/README.md`

## 📝 Available Files

### Installation Scripts
- `moonfixed-one-line-install.sh` - Complete one-line installer
- `install-algoritmit-moonfixed.sh` - Alternative installer
- `fix-moonfixed-rpc.sh` - RPC configuration fix script

### Diagnostic Tools
- `test-rpc-moonfixed.js` - Comprehensive RPC testing tool
- `moonfixed-correct-env.txt` - Correct environment configuration

### Download URLs
- **One-Line Installer:** https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/moonfixed-one-line-install.sh
- **Alternative Installer:** https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/install-algoritmit-moonfixed.sh
- **RPC Fix Script:** https://raw.githubusercontent.com/notevayasconadan/eva/cursor/check-repository-branches-for-latest-code-05c1/fix-moonfixed-rpc.sh

## ✅ Verified Configuration

The MoonFixed package includes:
- ✅ **Correct Chain ID:** 480 (Worldchain)
- ✅ **Working RPC URL:** https://worldchain-mainnet.g.alchemy.com/public
- ✅ **Tested endpoints:** Multiple fallback RPCs
- ✅ **Error handling:** Comprehensive retry mechanisms
- ✅ **Ubuntu optimized:** Server-ready installation
- ✅ **Novice friendly:** Detailed progress and instructions

---

*MoonFixed v4.0 - Complete package with fixed RPC configuration*
*Last updated: August 15, 2024*
*Repository: https://github.com/notevayasconadan/eva*