# 🌙 ALGORITMIT MoonFixed Trading Bot

## 🚀 Quick Start

1. **Configure the bot:**
   ```bash
   nano .env
   ```

2. **Start the bot:**
   ```bash
   ./start.sh
   ```

## 🛠️ Management Commands

- `./manage.sh start` - Start the MoonFixed bot
- `./manage.sh stop` - Stop the MoonFixed bot
- `./manage.sh restart` - Restart the MoonFixed bot
- `./manage.sh status` - Check bot status
- `./manage.sh logs` - View logs
- `./manage.sh config` - Edit configuration
- `./manage.sh test-rpc` - Test RPC connection
- `./manage.sh update` - Update the bot
- `./manage.sh backup` - Create backup

## ⚙️ Configuration

Edit the `.env` file to configure:
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
1. Check if Node.js is installed: `node --version`
2. Check if dependencies are installed: `ls node_modules`
3. Test RPC connection: `./manage.sh test-rpc`
4. Check configuration: `./manage.sh config`
5. View logs: `./manage.sh logs`

### RPC issues
1. Test RPC connection: `./manage.sh test-rpc`
2. Check RPC URL in .env file
3. Verify chain ID is 480
4. Check internet connectivity

### Dependencies issues
1. Clear npm cache: `npm cache clean --force`
2. Reinstall dependencies: `npm install`
3. Check package.json for correct versions

## 📊 Monitoring

- **Status**: `./manage.sh status`
- **Logs**: `./manage.sh logs`
- **Configuration**: `./manage.sh config`
- **RPC Test**: `./manage.sh test-rpc`

## 🔒 Security

- Never share your private key
- Use strong passwords
- Keep your .env file secure
- Regular backups: `./manage.sh backup`

## 🆘 Support

For help and support, visit: https://github.com/notevayasconadan/eva/issues

---
*MoonFixed v4.0 - Installed on: Fri Aug 15 06:35:10 PM UTC 2025*
*Installation directory: /workspace/algoritmit-moonfixed*
*RPC Configuration: FIXED for Worldchain (Chain ID: 480)*
