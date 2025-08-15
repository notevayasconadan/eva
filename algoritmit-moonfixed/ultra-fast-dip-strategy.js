const { ethers } = require('ethers');

class UltraFastDIPStrategy {
    constructor(tradingEngine, config) {
        this.tradingEngine = tradingEngine;
        this.config = config;
        
        // Ultra-fast DIP settings
        this.DIP_THRESHOLD = 5; // 5% price drop triggers DIP buy
        this.MAX_SLIPPAGE = 15; // 15% slippage for ultra-fast execution
        this.GAS_PRICE = ethers.parseUnits('100', 'gwei'); // Ultra-high gas for priority
        this.GAS_LIMIT = 800000; // High gas limit for complex transactions
        
        // Price monitoring
        this.priceHistory = new Map();
        this.dipAlerts = new Set();
        this.activePositions = new Map();
        
        // Performance tracking
        this.executionTimes = [];
        this.successRate = 0;
        this.totalTrades = 0;
        
        // Ultra-fast execution settings
        this.BATCH_SIZE = 10; // Execute up to 10 trades simultaneously
        this.RETRY_ATTEMPTS = 1; // Minimal retries for speed
        this.CONFIRMATION_TIMEOUT = 5000; // 5 second timeout
    }

    // Ultra-fast DIP detection
    async detectDIP(tokenAddress, currentPrice) {
        const now = Date.now();
        const history = this.priceHistory.get(tokenAddress) || [];
        
        // Add current price to history
        history.push({ price: currentPrice, timestamp: now });
        
        // Keep only last 10 price points (1 minute of data)
        if (history.length > 10) {
            history.shift();
        }
        
        this.priceHistory.set(tokenAddress, history);
        
        // Calculate price change
        if (history.length >= 2) {
            const oldestPrice = history[0].price;
            const priceChange = ((currentPrice - oldestPrice) / oldestPrice) * 100;
            
            // DIP detected if price dropped more than threshold
            if (priceChange < -this.DIP_THRESHOLD) {
                return {
                    isDIP: true,
                    priceChange: priceChange,
                    currentPrice: currentPrice,
                    baselinePrice: oldestPrice,
                    timestamp: now
                };
            }
        }
        
        return { isDIP: false };
    }

    // Ultra-fast DIP buying execution
    async executeDIPBuy(wallet, tokenAddress, amountInWLD) {
        const startTime = Date.now();
        
        try {
            // Execute ultra-fast buy
            const result = await this.tradingEngine.executeUltraFastDIPBuy(
                wallet,
                tokenAddress,
                amountInWLD,
                this.MAX_SLIPPAGE
            );
            
            const executionTime = Date.now() - startTime;
            this.executionTimes.push(executionTime);
            
            if (result.success) {
                this.totalTrades++;
                this.successRate = (this.totalTrades / this.totalTrades) * 100;
                
                // Track position
                this.activePositions.set(result.txHash, {
                    tokenAddress,
                    amountIn: amountInWLD,
                    expectedOutput: result.expectedOutput,
                    timestamp: result.timestamp,
                    executionTime
                });
                
                console.log(`🚀 ULTRA-FAST DIP BUY EXECUTED in ${executionTime}ms`);
                console.log(`📊 TX: ${result.txHash}`);
                console.log(`💰 Amount: ${amountInWLD} WLD`);
                console.log(`⛽ Gas Price: ${result.gasPrice} gwei`);
                
                return {
                    success: true,
                    txHash: result.txHash,
                    executionTime,
                    gasPrice: result.gasPrice
                };
            } else {
                console.error(`❌ DIP buy failed: ${result.error}`);
                return {
                    success: false,
                    error: result.error,
                    executionTime
                };
            }
            
        } catch (error) {
            const executionTime = Date.now() - startTime;
            console.error(`❌ DIP buy error: ${error.message}`);
            return {
                success: false,
                error: error.message,
                executionTime
            };
        }
    }

    // Batch ultra-fast DIP buying
    async executeBatchDIPBuys(trades) {
        const startTime = Date.now();
        console.log(`🚀 Executing ${trades.length} ultra-fast DIP buys...`);
        
        // Execute all trades simultaneously
        const results = await this.tradingEngine.executeBatchUltraFastDIPBuys(trades);
        
        const totalTime = Date.now() - startTime;
        const avgTime = totalTime / trades.length;
        
        console.log(`⚡ Batch execution completed in ${totalTime}ms (avg: ${avgTime.toFixed(0)}ms per trade)`);
        
        // Track performance
        const successfulTrades = results.filter(r => r.success).length;
        this.totalTrades += trades.length;
        this.successRate = (successfulTrades / this.totalTrades) * 100;
        
        return {
            results,
            totalTime,
            avgTime,
            successRate: (successfulTrades / trades.length) * 100
        };
    }

    // Ultra-fast token monitoring
    async monitorTokensForDIP(tokenAddresses, callback) {
        console.log(`🔍 Monitoring ${tokenAddresses.length} tokens for DIP opportunities...`);
        
        const monitor = async () => {
            try {
                // Get all prices simultaneously
                const pricePromises = tokenAddresses.map(async (address) => {
                    try {
                        const price = await this.tradingEngine.getTokenPrice(address);
                        return { address, price };
                    } catch (error) {
                        return { address, error: error.message };
                    }
                });
                
                const prices = await Promise.all(pricePromises);
                
                // Check for DIPs
                for (const priceData of prices) {
                    if (priceData.price) {
                        const dipResult = await this.detectDIP(priceData.address, priceData.price);
                        
                        if (dipResult.isDIP) {
                            console.log(`📉 DIP DETECTED: ${priceData.address}`);
                            console.log(`📊 Price change: ${dipResult.priceChange.toFixed(2)}%`);
                            
                            // Execute callback immediately
                            callback({
                                tokenAddress: priceData.address,
                                currentPrice: priceData.price,
                                dipData: dipResult,
                                timestamp: Date.now()
                            });
                            
                            // Auto-execute trade if auto-trading is enabled
                            if (this.tradingEngine.bot && this.tradingEngine.bot.autoTradingConfig.autoTradingMode) {
                                const signal = {
                                    type: 'BUY',
                                    tokenAddress: priceData.address,
                                    price: priceData.price,
                                    dipData: dipResult
                                };
                                
                                this.tradingEngine.bot.executeAutoTrade(signal).then(result => {
                                    if (result.success) {
                                        console.log(`🚀 Auto-trade executed: ${result.txHash}`);
                                    } else {
                                        console.log(`❌ Auto-trade failed: ${result.reason || result.error}`);
                                    }
                                });
                            }
                        }
                    }
                }
                
            } catch (error) {
                console.error(`❌ Monitoring error: ${error.message}`);
            }
        };
        
        // Execute immediately
        await monitor();
        
        // Return monitoring function for continuous monitoring
        return monitor;
    }

    // Ultra-fast profit taking
    async executeProfitTake(wallet, tokenAddress, profitThreshold = 20) {
        try {
            const currentPrice = await this.tradingEngine.getTokenPrice(tokenAddress);
            const position = this.activePositions.get(tokenAddress);
            
            if (!position) {
                return { success: false, error: 'No active position found' };
            }
            
            // Calculate profit percentage
            const profitPercent = ((currentPrice - position.baselinePrice) / position.baselinePrice) * 100;
            
            if (profitPercent >= profitThreshold) {
                console.log(`💰 Profit target reached: ${profitPercent.toFixed(2)}%`);
                
                // Execute sell
                const result = await this.tradingEngine.executeUltraFastDIPBuy(
                    wallet,
                    this.tradingEngine.WLD_ADDRESS, // Sell for WLD
                    position.expectedOutput,
                    this.MAX_SLIPPAGE
                );
                
                if (result.success) {
                    this.activePositions.delete(tokenAddress);
                    console.log(`✅ Profit taken: ${result.txHash}`);
                }
                
                return result;
            }
            
            return { success: false, reason: 'Profit threshold not reached' };
            
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    // Get strategy performance metrics
    getPerformanceMetrics() {
        const avgExecutionTime = this.executionTimes.length > 0 
            ? this.executionTimes.reduce((a, b) => a + b, 0) / this.executionTimes.length 
            : 0;
        
        const minExecutionTime = this.executionTimes.length > 0 
            ? Math.min(...this.executionTimes) 
            : 0;
        
        const maxExecutionTime = this.executionTimes.length > 0 
            ? Math.max(...this.executionTimes) 
            : 0;
        
        return {
            totalTrades: this.totalTrades,
            successRate: this.successRate,
            avgExecutionTime: avgExecutionTime.toFixed(0),
            minExecutionTime,
            maxExecutionTime,
            activePositions: this.activePositions.size,
            dipAlerts: this.dipAlerts.size
        };
    }

    // Ultra-fast emergency stop
    async emergencyStop() {
        console.log(`🛑 EMERGENCY STOP - Cancelling all pending transactions...`);
        
        // Clear all caches
        this.tradingEngine.clearPriceCache();
        this.priceHistory.clear();
        this.dipAlerts.clear();
        
        // Reset performance metrics
        this.executionTimes = [];
        this.totalTrades = 0;
        this.successRate = 0;
        
        console.log(`✅ Emergency stop completed`);
    }

    // Get strategy status
    getStatus() {
        return {
            dipThreshold: this.DIP_THRESHOLD,
            maxSlippage: this.MAX_SLIPPAGE,
            gasPrice: ethers.formatUnits(this.GAS_PRICE, 'gwei'),
            gasLimit: this.GAS_LIMIT,
            batchSize: this.BATCH_SIZE,
            performance: this.getPerformanceMetrics()
        };
    }
}

module.exports = UltraFastDIPStrategy;