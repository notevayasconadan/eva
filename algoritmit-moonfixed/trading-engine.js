const { ethers } = require('ethers');
const axios = require('axios');

class AdvancedTradingEngine {
    constructor(provider, config) {
        this.provider = provider;
        this.config = config;
        
        // Worldchain DEX addresses
        this.UNISWAP_V3_ROUTER = '0xE592427A0AEce92De3Edee1F18E0157C05861564';
        this.UNISWAP_V3_FACTORY = '0x1F98431c8aD98523631AE4a59f267346ea31F984';
        this.QUOTER_V2 = '0x61fFE014bA17989E743c5F6cB21bF9697530B21e';
        
        // WLD token on Worldchain
        this.WLD_ADDRESS = '0x2cfc85d8e48f8eab294be644d9e25c3030863003';
        
        // ABI definitions - OPUS 4.1: Optimized for speed
        this.ROUTER_ABI = [
            'function exactInputSingle((address tokenIn, address tokenOut, uint24 fee, address recipient, uint256 deadline, uint256 amountIn, uint256 amountOutMinimum, uint160 sqrtPriceLimitX96)) external returns (uint256 amountOut)',
            'function exactOutputSingle((address tokenIn, address tokenOut, uint24 fee, address recipient, uint256 deadline, uint256 amountOut, uint256 amountInMaximum, uint160 sqrtPriceLimitX96)) external returns (uint256 amountIn)'
        ];
        
        this.QUOTER_ABI = [
            'function quoteExactInputSingle(address tokenIn, address tokenOut, uint24 fee, uint256 amountIn, uint160 sqrtPriceLimitX96) external returns (uint256 amountOut)',
            'function quoteExactOutputSingle(address tokenIn, address tokenOut, uint24 fee, uint256 amountOut, uint160 sqrtPriceLimitX96) external returns (uint256 amountIn)'
        ];
        
        this.ERC20_ABI = [
            'function balanceOf(address owner) view returns (uint256)',
            'function decimals() view returns (uint8)',
            'function symbol() view returns (string)',
            'function name() view returns (string)',
            'function approve(address spender, uint256 amount) returns (bool)',
            'function allowance(address owner, address spender) view returns (uint256)',
            'function transfer(address to, uint256 amount) returns (bool)'
        ];
        
        // Initialize contracts - OPUS 4.1: Pre-initialized for speed
        this.routerContract = new ethers.Contract(this.UNISWAP_V3_ROUTER, this.ROUTER_ABI, this.provider);
        this.quoterContract = new ethers.Contract(this.QUOTER_V2, this.QUOTER_ABI, this.provider);
        
        // Fee tiers (0.05%, 0.3%, 1%) - OPUS 4.1: Optimized for speed
        this.FEE_TIERS = [500, 3000, 10000];
        
        // Price cache for high-speed trading - OPUS 4.1: Ultra-fast cache
        this.priceCache = new Map();
        this.lastPriceUpdate = new Map();
        
        // Transaction pool for batch processing - OPUS 4.1: Zero-delay queue
        this.transactionQueue = [];
        this.isProcessingQueue = false;
        
        // OPUS 4.1: Pre-allocated gas settings for ultra-fast execution
        this.ULTRA_FAST_GAS_PRICE = ethers.parseUnits('150', 'gwei'); // Ultra-high priority
        this.ULTRA_FAST_GAS_LIMIT = 1000000; // High gas limit for complex transactions
        this.ULTRA_FAST_PRIORITY_FEE = ethers.parseUnits('75', 'gwei'); // Maximum priority fee
        
        // OPUS 4.1: Pre-validated wallet cache
        this.walletCache = new Map();
        this.allowanceCache = new Map();
    }

    // OPUS 4.1: Ultra-fast price fetching with zero delays
    async getTokenPrice(tokenAddress, useCache = false) { // Disabled cache for real-time speed
        const cacheKey = `${tokenAddress}-${this.WLD_ADDRESS}`;
        const now = Date.now();
        
        // OPUS 4.1: Use cache only if extremely fresh (within 1 second)
        if (useCache && this.priceCache.has(cacheKey)) {
            const lastUpdate = this.lastPriceUpdate.get(cacheKey) || 0;
            if (now - lastUpdate < 1000) { // 1 second cache for ultra-speed
                return this.priceCache.get(cacheKey);
            }
        }
        
        try {
            // OPUS 4.1: Try only the fastest fee tier (0.3%) for maximum speed
            const fee = 3000; // 0.3% - fastest execution
            const amountIn = ethers.parseEther('1'); // 1 WLD
            
            const quote = await this.quoterContract.quoteExactInputSingle(
                this.WLD_ADDRESS,
                tokenAddress,
                fee,
                amountIn,
                0
            );
            
            const priceData = {
                fee,
                amountOut: quote,
                price: Number(ethers.formatEther(quote)),
                timestamp: now
            };
            
            // OPUS 4.1: Update cache immediately
            this.priceCache.set(cacheKey, priceData);
            this.lastPriceUpdate.set(cacheKey, now);
            
            return priceData;
            
        } catch (error) {
            // OPUS 4.1: Fallback to other fee tiers if needed
            for (const fee of [500, 10000]) {
                try {
                    const amountIn = ethers.parseEther('1');
                    const quote = await this.quoterContract.quoteExactInputSingle(
                        this.WLD_ADDRESS,
                        tokenAddress,
                        fee,
                        amountIn,
                        0
                    );
                    
                    const priceData = {
                        fee,
                        amountOut: quote,
                        price: Number(ethers.formatEther(quote)),
                        timestamp: now
                    };
                    
                    this.priceCache.set(cacheKey, priceData);
                    this.lastPriceUpdate.set(cacheKey, now);
                    
                    return priceData;
                } catch (fallbackError) {
                    continue;
                }
            }
            
            throw new Error(`No liquidity found for ${tokenAddress}`);
        }
    }

    // OPUS 4.1: Ultra-fast batch price fetching
    async getBatchPrices(tokenAddresses) {
        // OPUS 4.1: Execute all price queries in parallel with zero delays
        const pricePromises = tokenAddresses.map(async (address) => {
            try {
                const price = await this.getTokenPrice(address, false);
                return { address, ...price };
            } catch (error) {
                return { address, error: error.message };
            }
        });
        
        const results = await Promise.all(pricePromises);
        const priceMap = {};
        
        results.forEach(result => {
            priceMap[result.address] = result;
        });
        
        return priceMap;
    }

    // OPUS 4.1: Ultra-fast swap execution with zero delays
    async executeSwap(wallet, tokenIn, tokenOut, amountIn, slippageTolerance = 5) {
        const startTime = Date.now();
        
        try {
            // OPUS 4.1: Pre-validate wallet and create signer
            const signer = new ethers.Wallet(wallet.privateKey, this.provider);
            const tokenInContract = new ethers.Contract(tokenIn, this.ERC20_ABI, signer);
            const tokenOutContract = new ethers.Contract(tokenOut, this.ERC20_ABI, signer);
            
            // OPUS 4.1: Parallel validation for maximum speed
            const [tokenInDecimals, tokenOutDecimals, balance, allowance] = await Promise.all([
                tokenInContract.decimals(),
                tokenOutContract.decimals(),
                tokenInContract.balanceOf(wallet.address),
                tokenInContract.allowance(wallet.address, this.UNISWAP_V3_ROUTER)
            ]);
            
            const amountInWei = ethers.parseUnits(amountIn.toString(), tokenInDecimals);
            
            if (balance < amountInWei) {
                throw new Error(`Insufficient balance: ${ethers.formatUnits(balance, tokenInDecimals)} < ${amountIn}`);
            }
            
            // OPUS 4.1: Get quote with fastest fee tier
            const quote = await this.quoterContract.quoteExactInputSingle(
                tokenIn,
                tokenOut,
                3000, // 0.3% fee for speed
                amountInWei,
                0
            );
            
            // OPUS 4.1: Calculate minimum output with high slippage for speed
            const slippageMultiplier = BigInt(Math.floor((100 - slippageTolerance) * 100));
            const amountOutMinimum = (quote * slippageMultiplier) / BigInt(10000);
            
            // OPUS 4.1: Pre-approve if needed (parallel execution)
            let approvalPromise = Promise.resolve();
            if (allowance < amountInWei) {
                approvalPromise = tokenInContract.approve(this.UNISWAP_V3_ROUTER, ethers.MaxUint256);
            }
            
            // OPUS 4.1: Ultra-fast swap parameters
            const swapParams = {
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: 3000, // 0.3% fee
                recipient: wallet.address,
                deadline: Math.floor(Date.now() / 1000) + 300, // 5 minutes for speed
                amountIn: amountInWei,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            };
            
            // OPUS 4.1: Wait for approval if needed
            if (allowance < amountInWei) {
                await approvalPromise;
            }
            
            // OPUS 4.1: Execute with ultra-high gas for priority
            const routerContractWithSigner = this.routerContract.connect(signer);
            
            const swapTx = await routerContractWithSigner.exactInputSingle(swapParams, {
                gasLimit: this.ULTRA_FAST_GAS_LIMIT,
                gasPrice: this.ULTRA_FAST_GAS_PRICE,
                maxFeePerGas: this.ULTRA_FAST_GAS_PRICE,
                maxPriorityFeePerGas: this.ULTRA_FAST_PRIORITY_FEE
            });
            
            const executionTime = Date.now() - startTime;
            
            // OPUS 4.1: Return immediately without waiting for confirmation
            return {
                success: true,
                txHash: swapTx.hash,
                executionTime,
                gasPrice: ethers.formatUnits(this.ULTRA_FAST_GAS_PRICE, 'gwei'),
                amountIn: ethers.formatUnits(amountInWei, tokenInDecimals),
                expectedOutput: ethers.formatUnits(quote, tokenOutDecimals),
                fee: 3000,
                timestamp: Date.now()
            };
            
        } catch (error) {
            const executionTime = Date.now() - startTime;
            return {
                success: false,
                error: error.message,
                executionTime
            };
        }
    }

    // OPUS 4.1: Ultra-fast batch execution with zero delays
    async executeBatchSwaps(trades) {
        const startTime = Date.now();
        
        // OPUS 4.1: Execute all trades simultaneously for maximum speed
        const tradePromises = trades.map(trade => 
            this.executeSwap(
                trade.wallet,
                trade.tokenIn,
                trade.tokenOut,
                trade.amountIn,
                trade.slippageTolerance || 15 // High slippage for speed
            ).catch(error => ({
                success: false,
                error: error.message,
                trade: trade
            }))
        );
        
        const results = await Promise.all(tradePromises);
        const totalTime = Date.now() - startTime;
        
        return {
            results,
            totalTime,
            avgTime: totalTime / trades.length,
            successCount: results.filter(r => r.success).length
        };
    }

    // OPUS 4.1: Ultra-fast DIP buying with maximum speed
    async executeUltraFastDIPBuy(wallet, tokenAddress, amountInWLD, maxSlippage = 20) {
        const startTime = Date.now();
        
        try {
            // OPUS 4.1: Pre-validate everything before execution
            const signer = new ethers.Wallet(wallet.privateKey, this.provider);
            const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, signer);
            const wldContract = new ethers.Contract(this.WLD_ADDRESS, this.ERC20_ABI, signer);
            
            // OPUS 4.1: Parallel validation for maximum speed
            const [wldBalance, tokenDecimals, wldDecimals, currentAllowance] = await Promise.all([
                wldContract.balanceOf(wallet.address),
                tokenContract.decimals(),
                wldContract.decimals(),
                wldContract.allowance(wallet.address, this.UNISWAP_V3_ROUTER)
            ]);
            
            const amountInWei = ethers.parseUnits(amountInWLD.toString(), wldDecimals);
            
            // OPUS 4.1: Ultra-fast balance check
            if (wldBalance < amountInWei) {
                throw new Error(`Insufficient WLD balance: ${ethers.formatUnits(wldBalance, wldDecimals)} < ${amountInWLD}`);
            }
            
            // OPUS 4.1: Pre-approve if needed (parallel execution)
            let approvalPromise = Promise.resolve();
            if (currentAllowance < amountInWei) {
                approvalPromise = wldContract.approve(this.UNISWAP_V3_ROUTER, ethers.MaxUint256);
            }
            
            // OPUS 4.1: Get quote with ultra-high slippage for speed
            const quote = await this.quoterContract.quoteExactInputSingle(
                this.WLD_ADDRESS,
                tokenAddress,
                3000, // Use 0.3% fee tier for speed
                amountInWei,
                0
            );
            
            // OPUS 4.1: Calculate minimum output with high slippage tolerance
            const slippageMultiplier = BigInt(Math.floor((100 - maxSlippage) * 100));
            const amountOutMinimum = (quote * slippageMultiplier) / BigInt(10000);
            
            // OPUS 4.1: Wait for approval if needed
            if (currentAllowance < amountInWei) {
                await approvalPromise;
            }
            
            // OPUS 4.1: Ultra-fast swap parameters
            const swapParams = {
                tokenIn: this.WLD_ADDRESS,
                tokenOut: tokenAddress,
                fee: 3000,
                recipient: wallet.address,
                deadline: Math.floor(Date.now() / 1000) + 300, // 5 minutes for speed
                amountIn: amountInWei,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            };
            
            // OPUS 4.1: Execute with ultra-high gas for priority
            const routerContractWithSigner = this.routerContract.connect(signer);
            
            const swapTx = await routerContractWithSigner.exactInputSingle(swapParams, {
                gasLimit: this.ULTRA_FAST_GAS_LIMIT,
                gasPrice: this.ULTRA_FAST_GAS_PRICE,
                maxFeePerGas: this.ULTRA_FAST_GAS_PRICE,
                maxPriorityFeePerGas: this.ULTRA_FAST_PRIORITY_FEE
            });
            
            const executionTime = Date.now() - startTime;
            
            // OPUS 4.1: Return immediately without waiting for confirmation
            return {
                success: true,
                txHash: swapTx.hash,
                executionTime,
                gasPrice: ethers.formatUnits(this.ULTRA_FAST_GAS_PRICE, 'gwei'),
                expectedOutput: ethers.formatUnits(quote, tokenDecimals),
                amountIn: amountInWLD,
                timestamp: Date.now()
            };
            
        } catch (error) {
            const executionTime = Date.now() - startTime;
            return {
                success: false,
                error: error.message,
                executionTime
            };
        }
    }

    // OPUS 4.1: Batch ultra-fast DIP buying with zero delays
    async executeBatchUltraFastDIPBuys(trades) {
        const startTime = Date.now();
        
        // OPUS 4.1: Execute all trades simultaneously for maximum speed
        const tradePromises = trades.map(async (trade) => {
            try {
                return await this.executeUltraFastDIPBuy(
                    trade.wallet,
                    trade.tokenAddress,
                    trade.amountInWLD,
                    trade.maxSlippage || 20
                );
            } catch (error) {
                return {
                    success: false,
                    error: error.message,
                    trade: trade
                };
            }
        });
        
        // OPUS 4.1: Wait for all trades to complete
        const batchResults = await Promise.all(tradePromises);
        const totalTime = Date.now() - startTime;
        
        return {
            results: batchResults,
            totalTime,
            avgTime: totalTime / trades.length,
            successCount: batchResults.filter(r => r.success).length
        };
    }

    // OPUS 4.1: Ultra-fast price monitoring for DIP detection with zero delays
    async monitorPricesForDIP(tokenAddresses, callback, interval = 500) { // 500ms for ultra-speed
        const priceCache = new Map();
        
        const monitor = async () => {
            try {
                // OPUS 4.1: Get all prices in parallel with zero delays
                const pricePromises = tokenAddresses.map(async (address) => {
                    try {
                        const price = await this.getTokenPrice(address, false); // No cache for real-time
                        return { address, price: price.price };
                    } catch (error) {
                        return { address, error: error.message };
                    }
                });
                
                const prices = await Promise.all(pricePromises);
                
                // OPUS 4.1: Process prices immediately
                for (const priceData of prices) {
                    if (priceData.price) {
                        const lastPrice = priceCache.get(priceData.address);
                        priceCache.set(priceData.address, priceData.price);
                        
                        if (lastPrice) {
                            const priceChange = ((priceData.price - lastPrice) / lastPrice) * 100;
                            
                            // OPUS 4.1: Immediate callback for any significant change
                            if (Math.abs(priceChange) > 1) { // 1% threshold for ultra-speed
                                callback({
                                    tokenAddress: priceData.address,
                                    currentPrice: priceData.price,
                                    previousPrice: lastPrice,
                                    priceChange,
                                    timestamp: Date.now()
                                });
                            }
                        }
                    }
                }
                
            } catch (error) {
                console.error('OPUS 4.1 Price monitoring error:', error.message);
            }
        };
        
        // OPUS 4.1: Execute immediately and set interval
        await monitor();
        const intervalId = setInterval(monitor, interval);
        
        return () => clearInterval(intervalId);
    }

    // OPUS 4.1: Ultra-fast DIP detection and execution
    async detectAndExecuteDIP(wallet, tokenAddress, amountInWLD, dipThreshold = 5) {
        const startTime = Date.now();
        
        try {
            // OPUS 4.1: Get current price
            const currentPrice = await this.getTokenPrice(tokenAddress, false);
            
            // OPUS 4.1: Check if this is a DIP (price drop)
            const priceCacheKey = `dip_${tokenAddress}`;
            const lastPrice = this.priceCache.get(priceCacheKey);
            
            if (lastPrice && lastPrice.price) {
                const priceDrop = ((lastPrice.price - currentPrice.price) / lastPrice.price) * 100;
                
                if (priceDrop >= dipThreshold) {
                    console.log(`🚀 DIP DETECTED! Price dropped ${priceDrop.toFixed(2)}% - Executing ultra-fast buy...`);
                    
                    // OPUS 4.1: Execute ultra-fast DIP buy
                    const result = await this.executeUltraFastDIPBuy(wallet, tokenAddress, amountInWLD, 25);
                    
                    const totalTime = Date.now() - startTime;
                    
                    return {
                        ...result,
                        dipDetected: true,
                        priceDrop,
                        totalTime
                    };
                }
            }
            
            // OPUS 4.1: Update price cache
            this.priceCache.set(priceCacheKey, currentPrice);
            
            return {
                success: false,
                dipDetected: false,
                currentPrice: currentPrice.price,
                totalTime: Date.now() - startTime
            };
            
        } catch (error) {
            return {
                success: false,
                error: error.message,
                totalTime: Date.now() - startTime
            };
        }
    }

    // OPUS 4.1: Ultra-fast continuous DIP monitoring and execution
    async startUltraFastDIPBot(wallet, tokenAddress, amountInWLD, dipThreshold = 5, interval = 1000) {
        console.log(`🚀 Starting OPUS 4.1 Ultra-Fast DIP Bot for ${tokenAddress}`);
        console.log(`⚡ Monitoring every ${interval}ms with ${dipThreshold}% dip threshold`);
        
        const monitor = async () => {
            try {
                const result = await this.detectAndExecuteDIP(wallet, tokenAddress, amountInWLD, dipThreshold);
                
                if (result.dipDetected && result.success) {
                    console.log(`🎯 DIP BUY EXECUTED! TX: ${result.txHash}`);
                    console.log(`⚡ Execution time: ${result.executionTime}ms`);
                }
                
            } catch (error) {
                console.error('OPUS 4.1 DIP Bot error:', error.message);
            }
        };
        
        // OPUS 4.1: Execute immediately and set interval
        await monitor();
        const intervalId = setInterval(monitor, interval);
        
        return () => clearInterval(intervalId);
    }

    // Monitor price changes for arbitrage opportunities
    async monitorPriceChanges(tokenAddresses, callback, interval = 1000) { // Reduced to 1 second
        const monitor = async () => {
            try {
                const prices = await this.getBatchPrices(tokenAddresses);
                
                // Check for significant price changes
                for (const [address, priceData] of Object.entries(prices)) {
                    if (priceData.error) continue;
                    
                    const cacheKey = `monitor_${address}`;
                    const lastPrice = this.priceCache.get(cacheKey);
                    
                    if (lastPrice && lastPrice.price) {
                        const priceChange = ((priceData.price - lastPrice.price) / lastPrice.price) * 100;
                        
                        if (Math.abs(priceChange) > 1) { // 1% change threshold for speed
                            callback({
                                tokenAddress: address,
                                oldPrice: lastPrice.price,
                                newPrice: priceData.price,
                                change: priceChange,
                                timestamp: Date.now()
                            });
                        }
                    }
                    
                    this.priceCache.set(cacheKey, priceData);
                }
                
            } catch (error) {
                console.error('Price monitoring error:', error.message);
            }
        };
        
        // Initial run
        await monitor();
        
        // Set up interval
        const intervalId = setInterval(monitor, interval);
        
        return () => clearInterval(intervalId);
    }

    // Get optimal trading route for better prices
    async getOptimalRoute(tokenIn, tokenOut, amountIn) {
        // For now, direct swap is used, but this can be extended to multi-hop routing
        const directRoute = await this.getTokenPrice(tokenOut);
        
        return {
            route: [tokenIn, tokenOut],
            expectedOutput: directRoute.amountOut,
            fee: directRoute.fee,
            priceImpact: 0 // Would calculate based on liquidity
        };
    }

    // Calculate slippage and price impact
    calculateSlippage(expectedPrice, actualPrice) {
        return ((expectedPrice - actualPrice) / expectedPrice) * 100;
    }

    // Check if liquidity exists for a trading pair
    async checkPairLiquidity(tokenA, tokenB) {
        try {
            console.log(`🔍 Checking liquidity for pair...`);
            
            const feeTiers = [500, 3000, 10000]; // 0.05%, 0.3%, 1%
            let liquidityFound = false;
            const liquidityInfo = [];
            
            for (const fee of feeTiers) {
                try {
                    const quoterContract = new ethers.Contract(this.QUOTER_V2, this.QUOTER_ABI, this.provider);
                    
                    // Try a small test amount (0.001 tokens)
                    const testAmount = ethers.parseUnits('0.001', 18);
                    
                    const quote = await quoterContract.quoteExactInputSingle.staticCall({
                        tokenIn: tokenA,
                        tokenOut: tokenB,
                        fee: fee,
                        amountIn: testAmount,
                        sqrtPriceLimitX96: 0
                    });
                    
                    if (quote && quote > 0n) {
                        liquidityFound = true;
                        liquidityInfo.push({
                            fee: fee,
                            feePercent: (fee / 10000).toFixed(2),
                            hasLiquidity: true
                        });
                        console.log(`   ✅ Liquidity found at ${(fee / 10000).toFixed(2)}% fee tier`);
                    }
                } catch (error) {
                    liquidityInfo.push({
                        fee: fee,
                        feePercent: (fee / 10000).toFixed(2),
                        hasLiquidity: false,
                        error: error.message
                    });
                    console.log(`   ❌ No liquidity at ${(fee / 10000).toFixed(2)}% fee tier`);
                }
            }
            
            return {
                liquidityFound,
                liquidityInfo,
                tokenA,
                tokenB
            };
        } catch (error) {
            console.error('Error checking pair liquidity:', error.message);
            return {
                liquidityFound: false,
                error: error.message,
                tokenA,
                tokenB
            };
        }
    }

    // Get token information
    async getTokenInfo(tokenAddress) {
        try {
            const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, this.provider);
            
            const [name, symbol, decimals] = await Promise.all([
                tokenContract.name(),
                tokenContract.symbol(),
                tokenContract.decimals()
            ]);
            
            return {
                address: tokenAddress,
                name,
                symbol,
                decimals: Number(decimals)
            };
        } catch (error) {
            throw new Error(`Failed to get token info: ${error.message}`);
        }
    }

    // Get wallet token balances
    async getWalletBalances(walletAddress, tokenAddresses) {
        const balancePromises = tokenAddresses.map(async (tokenAddress) => {
            try {
                const tokenContract = new ethers.Contract(tokenAddress, this.ERC20_ABI, this.provider);
                const [balance, decimals, symbol] = await Promise.all([
                    tokenContract.balanceOf(walletAddress),
                    tokenContract.decimals(),
                    tokenContract.symbol()
                ]);
                
                return {
                    address: tokenAddress,
                    symbol,
                    balance: ethers.formatUnits(balance, decimals),
                    balanceWei: balance.toString()
                };
            } catch (error) {
                return {
                    address: tokenAddress,
                    error: error.message,
                    balance: '0'
                };
            }
        });
        
        return await Promise.all(balancePromises);
    }

    // Advanced portfolio analytics
    async getPortfolioAnalytics(walletAddress, tokenAddresses) {
        const balances = await this.getWalletBalances(walletAddress, tokenAddresses);
        const prices = await this.getBatchPrices(tokenAddresses);
        
        let totalValue = 0;
        const holdings = [];
        
        for (const balance of balances) {
            if (balance.error || parseFloat(balance.balance) === 0) continue;
            
            const price = prices[balance.address];
            if (price && !price.error) {
                const value = parseFloat(balance.balance) * price.price;
                totalValue += value;
                
                holdings.push({
                    ...balance,
                    price: price.price,
                    value: value,
                    percentage: 0 // Will be calculated after total
                });
            }
        }
        
        // Calculate percentages
        holdings.forEach(holding => {
            holding.percentage = (holding.value / totalValue) * 100;
        });
        
        return {
            totalValue,
            holdings: holdings.sort((a, b) => b.value - a.value),
            tokenCount: holdings.length,
            lastUpdated: Date.now()
        };
    }

    // Clear price cache
    clearCache() {
        this.priceCache.clear();
        this.lastPriceUpdate.clear();
    }

    // Get cache statistics
    getCacheStats() {
        return {
            cacheSize: this.priceCache.size,
            lastUpdateCount: this.lastPriceUpdate.size,
            oldestEntry: Math.min(...Array.from(this.lastPriceUpdate.values())),
            newestEntry: Math.max(...Array.from(this.lastPriceUpdate.values()))
        };
    }
}

module.exports = AdvancedTradingEngine;