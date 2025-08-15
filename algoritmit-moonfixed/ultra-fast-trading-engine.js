const { ethers } = require('ethers');
const axios = require('axios');

class UltraFastTradingEngine {
    constructor(provider, config) {
        this.provider = provider;
        this.config = config;
        
        // Worldchain DEX addresses
        this.UNISWAP_V3_ROUTER = '0xE592427A0AEce92De3Edee1F18E0157C05861564';
        this.QUOTER_V2 = '0x61fFE014bA17989E743c5F6cB21bF9697530B21e';
        this.WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        
        // Ultra-fast ABI (minimal for speed)
        this.ROUTER_ABI = [
            'function exactInputSingle((address tokenIn, address tokenOut, uint24 fee, address recipient, uint256 deadline, uint256 amountIn, uint256 amountOutMinimum, uint160 sqrtPriceLimitX96)) external returns (uint256 amountOut)',
            'function exactOutputSingle((address tokenIn, address tokenOut, uint24 fee, address recipient, uint256 deadline, uint256 amountOut, uint256 amountInMaximum, uint160 sqrtPriceLimitX96)) external returns (uint256 amountIn)'
        ];
        
        this.QUOTER_ABI = [
            'function quoteExactInputSingle(address tokenIn, address tokenOut, uint24 fee, uint256 amountIn, uint160 sqrtPriceLimitX96) external returns (uint256 amountOut)'
        ];
        
        this.ERC20_ABI = [
            'function balanceOf(address owner) view returns (uint256)',
            'function decimals() view returns (uint8)',
            'function approve(address spender, uint256 amount) returns (bool)',
            'function allowance(address owner, address spender) view returns (uint256)'
        ];
        
        // Initialize contracts
        this.routerContract = new ethers.Contract(this.UNISWAP_V3_ROUTER, this.ROUTER_ABI, this.provider);
        this.quoterContract = new ethers.Contract(this.QUOTER_V2, this.QUOTER_ABI, this.provider);
        
        // Ultra-fast settings
        this.FEE_TIERS = [500, 3000, 10000]; // 0.05%, 0.3%, 1%
        this.MAX_SLIPPAGE = 10; // 10% for ultra-fast execution
        this.GAS_LIMIT = 500000; // High gas limit for speed
        this.GAS_PRICE = ethers.parseUnits('50', 'gwei'); // High gas price for priority
        
        // Pre-approved allowances cache
        this.approvedTokens = new Set();
        
        // Price cache for instant access
        this.priceCache = new Map();
        this.cacheTimeout = 1000; // 1 second cache
        
        // Transaction pool for instant execution
        this.pendingTxs = new Map();
    }

    // Ultra-fast price fetching (no delays)
    async getTokenPrice(tokenAddress) {
        const cacheKey = tokenAddress;
        const now = Date.now();
        
        // Use cache if fresh
        if (this.priceCache.has(cacheKey)) {
            const cached = this.priceCache.get(cacheKey);
            if (now - cached.timestamp < this.cacheTimeout) {
                return cached.price;
            }
        }
        
        try {
            // Try all fee tiers simultaneously
            const amountIn = ethers.parseEther('1');
            const pricePromises = this.FEE_TIERS.map(fee => 
                this.quoterContract.quoteExactInputSingle(
                    this.WLD_ADDRESS,
                    tokenAddress,
                    fee,
                    amountIn,
                    0
                ).catch(() => null)
            );
            
            const quotes = await Promise.all(pricePromises);
            const validQuotes = quotes.filter(q => q !== null);
            
            if (validQuotes.length === 0) {
                throw new Error('No liquidity');
            }
            
            // Use highest quote (best price)
            const bestQuote = validQuotes.reduce((max, q) => q > max ? q : max);
            const price = Number(ethers.formatEther(bestQuote));
            
            // Cache the result
            this.priceCache.set(cacheKey, { price, timestamp: now });
            
            return price;
        } catch (error) {
            throw new Error(`Price fetch failed: ${error.message}`);
        }
    }

    // Ultra-fast DIP buying (no delays, maximum speed)
    async executeUltraFastDIPBuy(wallet, tokenAddress, amountInWLD, slippageTolerance = 10) {
        try {
            const signer = wallet.connect(this.provider);
            const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, signer);
            
            // Get token decimals
            const decimals = await tokenContract.decimals();
            
            // Convert amount to Wei
            const amountInWei = ethers.parseEther(amountInWLD.toString());
            
            // Get quote instantly (no delays)
            const amountIn = ethers.parseEther('1');
            const quote = await this.quoterContract.quoteExactInputSingle(
                this.WLD_ADDRESS,
                tokenAddress,
                500, // Use 0.05% fee for speed
                amountIn,
                0
            );
            
            // Calculate expected output
            const expectedOutput = (quote * amountInWei) / amountIn;
            const minOutput = (expectedOutput * BigInt(100 - slippageTolerance)) / BigInt(100);
            
            // Check allowance (skip if already approved)
            if (!this.approvedTokens.has(tokenAddress)) {
                const allowance = await tokenContract.allowance(wallet.address, this.UNISWAP_V3_ROUTER);
                if (allowance < amountInWei) {
                    const approveTx = await tokenContract.approve(this.UNISWAP_V3_ROUTER, ethers.MaxUint256, {
                        gasLimit: 100000,
                        gasPrice: this.GAS_PRICE
                    });
                    await approveTx.wait();
                    this.approvedTokens.add(tokenAddress);
                }
            }
            
            // Prepare ultra-fast swap parameters
            const swapParams = {
                tokenIn: this.WLD_ADDRESS,
                tokenOut: tokenAddress,
                fee: 500, // 0.05% fee for speed
                recipient: wallet.address,
                deadline: Math.floor(Date.now() / 1000) + 60, // 1 minute deadline
                amountIn: amountInWei,
                amountOutMinimum: minOutput,
                sqrtPriceLimitX96: 0
            };
            
            // Execute swap with maximum speed settings
            const routerWithSigner = this.routerContract.connect(signer);
            
            const swapTx = await routerWithSigner.exactInputSingle(swapParams, {
                gasLimit: this.GAS_LIMIT,
                gasPrice: this.GAS_PRICE,
                maxFeePerGas: this.GAS_PRICE,
                maxPriorityFeePerGas: ethers.parseUnits('2', 'gwei')
            });
            
            // Don't wait for confirmation - return immediately
            return {
                success: true,
                txHash: swapTx.hash,
                amountIn: amountInWLD,
                expectedOutput: ethers.formatUnits(expectedOutput, decimals),
                gasPrice: ethers.formatUnits(this.GAS_PRICE, 'gwei'),
                timestamp: Date.now()
            };
            
        } catch (error) {
            return {
                success: false,
                error: error.message,
                timestamp: Date.now()
            };
        }
    }

    // Batch ultra-fast DIP buying
    async executeBatchUltraFastDIPBuys(trades) {
        const results = [];
        
        // Execute all trades simultaneously (no batching delays)
        const tradePromises = trades.map(trade => 
            this.executeUltraFastDIPBuy(
                trade.wallet,
                trade.tokenAddress,
                trade.amountInWLD,
                trade.slippageTolerance || 10
            )
        );
        
        const batchResults = await Promise.all(tradePromises);
        results.push(...batchResults);
        
        return results;
    }

    // Ultra-fast token discovery
    async discoverTokens() {
        try {
            // Use multiple sources simultaneously
            const discoveryPromises = [
                this.getTokensFromDexScreener(),
                this.getTokensFromDexTools(),
                this.getTokensFromChainScan()
            ];
            
            const results = await Promise.all(discoveryPromises);
            
            // Merge and deduplicate results
            const allTokens = new Map();
            results.forEach(tokenList => {
                tokenList.forEach(token => {
                    if (!allTokens.has(token.address)) {
                        allTokens.set(token.address, token);
                    }
                });
            });
            
            return Array.from(allTokens.values());
        } catch (error) {
            console.error('Token discovery failed:', error.message);
            return [];
        }
    }

    // Get tokens from DexScreener (ultra-fast)
    async getTokensFromDexScreener() {
        try {
            const response = await axios.get('https://api.dexscreener.com/latest/dex/tokens/worldchain', {
                timeout: 2000 // 2 second timeout
            });
            
            return response.data.pairs?.map(pair => ({
                address: pair.baseToken.address,
                symbol: pair.baseToken.symbol,
                name: pair.baseToken.name,
                price: pair.priceUsd,
                volume24h: pair.volume.h24,
                liquidity: pair.liquidity.usd
            })) || [];
        } catch (error) {
            return [];
        }
    }

    // Get tokens from DexTools (ultra-fast)
    async getTokensFromDexTools() {
        try {
            const response = await axios.get('https://www.dextools.io/api/v1/token/worldchain/list', {
                timeout: 2000
            });
            
            return response.data.data?.map(token => ({
                address: token.address,
                symbol: token.symbol,
                name: token.name,
                price: token.price,
                volume24h: token.volume24h
            })) || [];
        } catch (error) {
            return [];
        }
    }

    // Get tokens from ChainScan (ultra-fast)
    async getTokensFromChainScan() {
        try {
            const response = await axios.get('https://api.worldchain.org/tokens', {
                timeout: 2000
            });
            
            return response.data.tokens?.map(token => ({
                address: token.address,
                symbol: token.symbol,
                name: token.name,
                price: token.price
            })) || [];
        } catch (error) {
            return [];
        }
    }

    // Ultra-fast price monitoring (no intervals, instant execution)
    async monitorPriceChanges(tokenAddresses, callback) {
        const prices = await Promise.all(
            tokenAddresses.map(async (address) => {
                try {
                    const price = await this.getTokenPrice(address);
                    return { address, price, timestamp: Date.now() };
                } catch (error) {
                    return { address, error: error.message };
                }
            })
        );
        
        // Execute callback immediately for any significant changes
        prices.forEach(priceData => {
            if (priceData.price) {
                callback(priceData);
            }
        });
        
        return prices;
    }

    // Get wallet balance (ultra-fast)
    async getWalletBalance(wallet, tokenAddress = this.WLD_ADDRESS) {
        try {
            const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, this.provider);
            const balance = await tokenContract.balanceOf(wallet.address);
            const decimals = await tokenContract.decimals();
            return ethers.formatUnits(balance, decimals);
        } catch (error) {
            return '0';
        }
    }

    // Clear price cache
    clearPriceCache() {
        this.priceCache.clear();
    }

    // Get engine status
    getStatus() {
        return {
            provider: this.provider.connection.url,
            gasPrice: ethers.formatUnits(this.GAS_PRICE, 'gwei'),
            gasLimit: this.GAS_LIMIT,
            maxSlippage: this.MAX_SLIPPAGE,
            cacheSize: this.priceCache.size,
            approvedTokens: this.approvedTokens.size
        };
    }
}

module.exports = UltraFastTradingEngine;