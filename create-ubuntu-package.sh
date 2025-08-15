#!/bin/bash

# 🤖 ALGORITMIT Ubuntu Package Creator v4.0
# Script to create the complete Ubuntu server package for distribution

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
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

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_header() {
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
}

# Package configuration
PACKAGE_NAME="algoritmit-ubuntu-server-v4.0-novice"
PACKAGE_DIR="packages/$PACKAGE_NAME"
RELEASE_DIR="releases"
VERSION="4.0.0"

print_header "ALGORITMIT Ubuntu Package Creator v$VERSION"

# Check if package directory exists
if [[ ! -d "$PACKAGE_DIR" ]]; then
    print_error "Package directory not found: $PACKAGE_DIR"
    exit 1
fi

# Create release directory
mkdir -p "$RELEASE_DIR"

print_status "Creating Ubuntu server package..."

# Copy additional files to package
print_status "Copying additional files..."

# Copy test files
cp test-*.js "$PACKAGE_DIR/" 2>/dev/null || true

# Copy utility scripts
cp *.sh "$PACKAGE_DIR/" 2>/dev/null || true

# Copy documentation
cp *.md "$PACKAGE_DIR/" 2>/dev/null || true

# Create package info file
cat > "$PACKAGE_DIR/PACKAGE_INFO.txt" << EOF
ALGORITMIT Ubuntu Server Package v$VERSION
==========================================

Package Name: $PACKAGE_NAME
Version: $VERSION
Release Date: $(date)
Target OS: Ubuntu 20.04, 22.04, 24.04
Architecture: x86_64

Contents:
- Complete ALGORITMIT v4.0 Trading Bot
- Ubuntu Server Installation Scripts
- Novice Trader Documentation
- Configuration Templates
- Management Scripts

Installation:
1. Extract package: tar -xzf $PACKAGE_NAME.tar.gz
2. Run installer: sudo ./install-algoritmit-ubuntu-root.sh
3. Configure: edit .env file
4. Start bot: algoritmit start

For more information, see README.md
EOF

# Create checksums
print_status "Creating checksums..."

cd "$PACKAGE_DIR"
find . -type f -name "*.js" -o -name "*.json" -o -name "*.md" -o -name "*.sh" | sort | xargs sha256sum > checksums.txt

# Create package archive
print_status "Creating package archive..."

cd ../..
tar -czf "$RELEASE_DIR/$PACKAGE_NAME.tar.gz" "$PACKAGE_NAME/"

# Create checksum for the package
cd "$RELEASE_DIR"
sha256sum "$PACKAGE_NAME.tar.gz" > "$PACKAGE_NAME.tar.gz.sha256"

# Get package size
PACKAGE_SIZE=$(du -h "$PACKAGE_NAME.tar.gz" | cut -f1)

print_success "Package created successfully!"
echo ""
echo -e "${WHITE}📦 Package Details:${NC}"
echo -e "  Name: $PACKAGE_NAME.tar.gz"
echo -e "  Size: $PACKAGE_SIZE"
echo -e "  Location: $RELEASE_DIR/$PACKAGE_NAME.tar.gz"
echo -e "  Checksum: $RELEASE_DIR/$PACKAGE_NAME.tar.gz.sha256"
echo ""

# Create installation instructions
cat > "$RELEASE_DIR/INSTALL_UBUNTU_SERVER.md" << 'EOF'
# 🚀 ALGORITMIT Ubuntu Server Installation

## Quick Install (One-Line)

### For Root Users:
```bash
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/main/install-algoritmit-ubuntu-root.sh | sudo bash
```

### For Non-Root Users:
```bash
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/main/install-algoritmit-ubuntu-novice.sh | bash
```

## Manual Installation

1. **Download the package:**
   ```bash
   wget https://github.com/notevayasconadan/eva/releases/download/v4.0/algoritmit-ubuntu-server-v4.0-novice.tar.gz
   ```

2. **Extract the package:**
   ```bash
   tar -xzf algoritmit-ubuntu-server-v4.0-novice.tar.gz
   cd algoritmit-ubuntu-server-v4.0-novice
   ```

3. **Run the installer:**
   ```bash
   sudo ./install-algoritmit-ubuntu-root.sh
   ```

4. **Configure the bot:**
   ```bash
   sudo nano .env
   ```

5. **Start the bot:**
   ```bash
   algoritmit start
   ```

## System Requirements

- Ubuntu 20.04, 22.04, or 24.04
- Minimum 2GB RAM (4GB recommended)
- 10GB free disk space
- Root access or sudo privileges
- Stable internet connection

## Support

- **Documentation:** See README.md in the package
- **Community:** https://t.me/algoritmit_community
- **Issues:** https://github.com/notevayasconadan/eva/issues
EOF

print_status "Installation instructions created: $RELEASE_DIR/INSTALL_UBUNTU_SERVER.md"

# Create GitHub release notes
cat > "$RELEASE_DIR/RELEASE_NOTES_v$VERSION.md" << EOF
# ALGORITMIT Ubuntu Server Package v$VERSION

## 🎉 What's New

- **Complete Ubuntu Server Package** - Ready-to-install package for Ubuntu servers
- **Novice Trader Focus** - Designed specifically for beginner traders
- **Root & User Installation** - Support for both root and non-root installations
- **Comprehensive Documentation** - Complete guides for setup and configuration
- **Safety Features** - Built-in learning mode and risk management

## 📦 Package Contents

- ✅ Complete ALGORITMIT v4.0 Trading Bot
- ✅ Ubuntu Server Installation Scripts
- ✅ Novice Trader Documentation
- ✅ Configuration Templates
- ✅ Management Scripts
- ✅ Troubleshooting Guide
- ✅ Quick Start Guide

## 🚀 Installation

### One-Line Installation

**Root Users:**
\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/main/install-algoritmit-ubuntu-root.sh | sudo bash
\`\`\`

**Non-Root Users:**
\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/notevayasconadan/eva/main/install-algoritmit-ubuntu-novice.sh | bash
\`\`\`

### Manual Installation

1. Download: \`wget https://github.com/notevayasconadan/eva/releases/download/v4.0/algoritmit-ubuntu-server-v4.0-novice.tar.gz\`
2. Extract: \`tar -xzf algoritmit-ubuntu-server-v4.0-novice.tar.gz\`
3. Install: \`sudo ./install-algoritmit-ubuntu-root.sh\`
4. Configure: \`sudo nano .env\`
5. Start: \`algoritmit start\`

## 🎯 For Novice Traders

- **Learning Mode** - Start with AI learning without trading
- **Paper Trading** - Test strategies with simulated trades
- **Safety Features** - Built-in stop losses and position limits
- **Step-by-Step Guides** - Complete documentation for beginners

## 🔧 System Requirements

- Ubuntu 20.04, 22.04, or 24.04
- Minimum 2GB RAM (4GB recommended)
- 10GB free disk space
- Root access or sudo privileges
- Stable internet connection

## 📚 Documentation

- **README.md** - Complete package overview
- **QUICK_START.md** - Get started in 10 minutes
- **CONFIGURATION_GUIDE.md** - Detailed configuration guide
- **TROUBLESHOOTING.md** - Common issues and solutions

## 🛡️ Safety Features

- Learning mode for beginners
- Configurable position sizes
- Stop loss protection
- Daily loss limits
- Emergency stop functionality

## 📞 Support

- **Telegram Community:** https://t.me/algoritmit_community
- **Discord Server:** https://discord.gg/algoritmit
- **GitHub Issues:** https://github.com/notevayasconadan/eva/issues
- **Email:** support@algoritmit.com

---

**Happy Trading! 🚀**
EOF

print_success "Release notes created: $RELEASE_DIR/RELEASE_NOTES_v$VERSION.md"

# Final summary
print_header "Package Creation Complete"

echo -e "${WHITE}📦 Package Summary:${NC}"
echo -e "  Package: $PACKAGE_NAME.tar.gz"
echo -e "  Size: $PACKAGE_SIZE"
echo -e "  Version: $VERSION"
echo -e "  Target: Ubuntu Server (Novice Traders)"
echo ""
echo -e "${WHITE}📁 Files Created:${NC}"
echo -e "  • $RELEASE_DIR/$PACKAGE_NAME.tar.gz"
echo -e "  • $RELEASE_DIR/$PACKAGE_NAME.tar.gz.sha256"
echo -e "  • $RELEASE_DIR/INSTALL_UBUNTU_SERVER.md"
echo -e "  • $RELEASE_DIR/RELEASE_NOTES_v$VERSION.md"
echo ""
echo -e "${WHITE}🚀 Next Steps:${NC}"
echo -e "  1. Upload package to GitHub releases"
echo -e "  2. Update download links in documentation"
echo -e "  3. Share with the community"
echo ""
echo -e "${GREEN}✅ Package ready for distribution!${NC}"