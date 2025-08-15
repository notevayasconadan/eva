# 🔧 ALGORITMIT Troubleshooting Guide for Novice Traders

**Complete troubleshooting guide for resolving common ALGORITMIT issues on Ubuntu Server**

## 🚨 Emergency Procedures

### Immediate Stop (Emergency)
```bash
# Stop all trading immediately
algoritmit emergency-stop

# Or stop the service
algoritmit stop

# For system service
sudo systemctl stop algoritmit
```

### Check Bot Status
```bash
# Check if bot is running
algoritmit status

# Check system service status
sudo systemctl status algoritmit

# Check user service status
systemctl --user status algoritmit
```

## 📊 Diagnostic Commands

### System Health Check
```bash
# Check system resources
htop
df -h
free -h

# Check network connectivity
ping -c 3 google.com
ping -c 3 worldcoin.org

# Check Node.js version
node --version
npm --version
```

### Bot Health Check
```bash
# Check bot logs
algoritmit logs

# Check configuration
algoritmit validate-config

# Test all connections
algoritmit test-all

# Check wallet balance
algoritmit balance
```

## 🔍 Common Issues & Solutions

### Issue 1: "Node.js not found" or "Node.js version too old"

**Symptoms:**
- Error: `node: command not found`
- Error: `Node.js version must be >= 16.0.0`

**Solution:**
```bash
# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

**Alternative Solution:**
```bash
# Using Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 18
nvm use 18
```

### Issue 2: "Permission denied" errors

**Symptoms:**
- Error: `Permission denied`
- Error: `EACCES: permission denied`

**Solution:**
```bash
# Fix ownership for user installation
sudo chown -R $USER:$USER ~/algoritmit
chmod +x ~/algoritmit/algoritmit-ubuntu-server-v4.0-novice/*.sh

# Fix ownership for root installation
sudo chown -R root:root /opt/algoritmit
sudo chmod -R 755 /opt/algoritmit
```

### Issue 3: "Connection failed" or "Network timeout"

**Symptoms:**
- Error: `Connection failed`
- Error: `Network timeout`
- Error: `ECONNREFUSED`

**Solution:**
```bash
# Test internet connection
ping -c 3 google.com

# Test RPC connection
curl -X POST https://worldchain-mainnet.g.alchemy.com/public

# Check firewall settings
sudo ufw status

# Test with different RPC
curl -X POST https://rpc.worldcoin.org
```

### Issue 4: "Invalid private key" or "Wallet error"

**Symptoms:**
- Error: `Invalid private key`
- Error: `Wallet not found`
- Error: `Insufficient funds`

**Solution:**
```bash
# Check private key format
# Should start with 0x and be 64 characters long
echo "0x1234567890abcdef..." | wc -c

# Verify wallet balance
algoritmit balance

# Test wallet connection
algoritmit test-wallet

# Check configuration
algoritmit validate-config
```

### Issue 5: "Service failed to start"

**Symptoms:**
- Error: `Failed to start algoritmit.service`
- Error: `Unit algoritmit.service failed`

**Solution:**
```bash
# Check service logs
sudo journalctl -u algoritmit -f

# Check service file
sudo cat /etc/systemd/system/algoritmit.service

# Reload systemd
sudo systemctl daemon-reload

# Restart service
sudo systemctl restart algoritmit
```

### Issue 6: "npm install failed"

**Symptoms:**
- Error: `npm ERR!`
- Error: `Failed to install dependencies`

**Solution:**
```bash
# Clear npm cache
sudo npm cache clean --force

# Remove node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Try with different npm registry
npm config set registry https://registry.npmjs.org/
npm install
```

### Issue 7: "Telegram notifications not working"

**Symptoms:**
- No Telegram messages received
- Error: `Telegram bot error`

**Solution:**
```bash
# Test Telegram bot
algoritmit test-telegram

# Verify bot token format
# Should be like: 1234567890:ABCdefGHIjklMNOpqrsTUVwxyz

# Check chat ID
# Should be a number like: 123456789

# Test manually
curl -X POST https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage \
  -d "chat_id=<YOUR_CHAT_ID>" \
  -d "text=Test message"
```

### Issue 8: "Insufficient gas" or "Gas estimation failed"

**Symptoms:**
- Error: `Insufficient gas`
- Error: `Gas estimation failed`
- Error: `Transaction failed`

**Solution:**
```bash
# Check wallet balance
algoritmit balance

# Increase gas limit buffer in .env
GAS_LIMIT_BUFFER=1.5

# Check gas prices
algoritmit gas-price

# Add more WLD for gas fees
```

### Issue 9: "Bot not trading" or "No trades executed"

**Symptoms:**
- Bot running but no trades
- Error: `No trading opportunities`

**Solution:**
```bash
# Check trading settings
algoritmit config

# Verify these settings:
# ML_AUTO_TRADING=true
# ML_LEARNING_MODE=false
# PAPER_TRADING=false (for live trading)

# Check confidence threshold
# Lower it if too high: ML_CONFIDENCE_THRESHOLD=65

# Check position size
# Ensure it's not too small: ML_MAX_POSITION_SIZE=0.01
```

### Issue 10: "High CPU usage" or "Memory issues"

**Symptoms:**
- High CPU usage
- Out of memory errors
- System slowdown

**Solution:**
```bash
# Check system resources
htop
free -h

# Optimize performance settings in .env
PRICE_CHECK_INTERVAL=5  # Increase interval
LOG_LEVEL=warn          # Reduce logging
LOG_TO_CONSOLE=false    # Disable console logging

# Restart bot
algoritmit restart
```

## 🔧 Advanced Troubleshooting

### Debug Mode

```bash
# Enable debug logging
# Edit .env file:
LOG_LEVEL=debug
LOG_TO_CONSOLE=true

# Restart bot
algoritmit restart

# Monitor logs
algoritmit logs
```

### Reset Configuration

```bash
# Backup current config
cp .env .env.backup

# Reset to defaults
cp .env.example .env

# Edit new config
algoritmit config
```

### Complete Reinstall

```bash
# Stop bot
algoritmit stop

# Backup important files
cp .env .env.backup
cp wallets.json wallets.json.backup

# Remove installation
algoritmit uninstall

# Reinstall
curl -fsSL https://raw.githubusercontent.com/romerodevv/psgho/main/install-algoritmit-ubuntu-root.sh | sudo bash

# Restore configuration
cp .env.backup .env
```

## 📱 Telegram Bot Troubleshooting

### Bot Not Responding

1. **Check Bot Status:**
   ```bash
   curl https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getMe
   ```

2. **Verify Chat ID:**
   ```bash
   curl https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
   ```

3. **Test Message:**
   ```bash
   curl -X POST https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage \
     -d "chat_id=<YOUR_CHAT_ID>" \
     -d "text=Test message"
   ```

### Common Telegram Issues

- **Bot blocked:** Unblock the bot in Telegram
- **Wrong chat ID:** Get correct chat ID from getUpdates
- **Invalid token:** Verify bot token with @BotFather
- **Rate limiting:** Wait a few minutes between messages

## 🌐 Network Troubleshooting

### RPC Connection Issues

```bash
# Test different RPC endpoints
curl -X POST https://worldchain-mainnet.g.alchemy.com/public
curl -X POST https://rpc.worldcoin.org
curl -X POST https://worldchain.drpc.org

# Check DNS resolution
nslookup worldchain-mainnet.g.alchemy.com
nslookup rpc.worldcoin.org

# Test with different network
curl -X POST https://worldchain-mainnet.g.alchemy.com/public \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### Firewall Issues

```bash
# Check firewall status
sudo ufw status

# Allow outbound connections
sudo ufw allow out 443
sudo ufw allow out 80

# Check if port 8545 is blocked (if using local RPC)
sudo ufw allow 8545
```

## 💾 Database & Storage Issues

### Log File Issues

```bash
# Check log file size
ls -lh logs/bot.log

# Rotate logs if too large
sudo logrotate -f /etc/logrotate.d/algoritmit

# Clear old logs
sudo find /opt/algoritmit -name "*.log" -mtime +7 -delete
```

### Database Issues

```bash
# Check database file
ls -lh data/trading.db

# Backup database
cp data/trading.db data/trading.db.backup

# Recreate database (if corrupted)
rm data/trading.db
algoritmit start
```

## 🔄 Performance Optimization

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

```env
# Optimize .env settings
PRICE_CHECK_INTERVAL=5      # Check less frequently
LOG_LEVEL=warn              # Reduce logging
LOG_TO_CONSOLE=false        # Disable console output
MAX_CONCURRENT_TRADES=2     # Reduce concurrent trades
```

## 📞 Getting Help

### Before Asking for Help

1. **Check logs:** `algoritmit logs`
2. **Run diagnostics:** `algoritmit test-all`
3. **Check system:** `htop`, `df -h`, `free -h`
4. **Verify config:** `algoritmit validate-config`

### Information to Provide

When asking for help, include:

- **Error message:** Exact error text
- **Logs:** Recent log entries
- **System info:** Ubuntu version, Node.js version
- **Configuration:** Relevant .env settings (without private keys)
- **Steps taken:** What you've already tried

### Support Channels

- **Telegram Group:** [ALGORITMIT Community](https://t.me/algoritmit_community)
- **Discord Server:** [ALGORITMIT Discord](https://discord.gg/algoritmit)
- **GitHub Issues:** [Report Issues](https://github.com/romerodevv/psgho/issues)
- **Email:** support@algoritmit.com

## 🛡️ Security Checklist

### After Troubleshooting

1. **Verify private key security:**
   - Private key not in logs
   - .env file permissions correct
   - No private key in error messages

2. **Check system security:**
   - Firewall configured
   - SSH keys only (no password)
   - Regular updates

3. **Monitor for issues:**
   - Set up monitoring
   - Regular log review
   - Performance tracking

---

**Remember: When in doubt, stop trading and seek help! 🚨**