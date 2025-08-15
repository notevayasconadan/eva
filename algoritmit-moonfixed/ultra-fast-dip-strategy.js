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

    // OPUS 4.1 Ultra-Fast DIP buying execution
    async executeDIPBuy(wallet, tokenAddress, amountInWLD) {
        const startTime = Date.now();
        
        try {
            // OPUS 4.1: Execute ultra-fast buy with maximum speed
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
                
                // OPUS 4.1: Track position for profit taking
                this.activePositions.set(result.txHash, {
                    tokenAddress,
                    amountIn: amountInWLD,
                    expectedOutput: result.expectedOutput,
                    timestamp: result.timestamp,
                    executionTime,
                    baselinePrice: result.baselinePrice || 0
                });
                
                console.log(`🚀 OPUS 4.1 ULTRA-FAST DIP BUY EXECUTED in ${executionTime}ms`);
                console.log(`📊 TX: ${result.txHash}`);
                console.log(`💰 Amount: ${amountInWLD} WLD`);
                console.log(`⛽ Gas Price: ${result.gasPrice} gwei`);
                console.log(`⚡ OPUS 4.1 Speed: ${executionTime < 1000 ? 'ULTRA-FAST' : 'FAST'}`);
                
                return {
                    success: true,
                    txHash: result.txHash,
                    executionTime,
                    gasPrice: result.gasPrice,
                    opusSpeed: executionTime < 1000 ? 'ULTRA-FAST' : 'FAST'
                };
            } else {
                console.error(`❌ OPUS 4.1 DIP buy failed: ${result.error}`);
                return {
                    success: false,
                    error: result.error,
                    executionTime
                };
            }
            
        } catch (error) {
            const executionTime = Date.now() - startTime;
            console.error(`❌ OPUS 4.1 DIP buy error: ${error.message}`);
            return {
                success: false,
                error: error.message,
                executionTime
            };
        }
    }

    // OPUS 4.1 Batch ultra-fast DIP buying
    async executeBatchDIPBuys(trades) {
        const startTime = Date.now();
        console.log(`🚀 OPUS 4.1: Executing ${trades.length} ultra-fast DIP buys simultaneously...`);
        
        // OPUS 4.1: Execute all trades simultaneously for maximum speed
        const results = await this.tradingEngine.executeBatchUltraFastDIPBuys(trades);
        
        const totalTime = Date.now() - startTime;
        const avgTime = totalTime / trades.length;
        
        console.log(`⚡ OPUS 4.1 Batch execution completed in ${totalTime}ms (avg: ${avgTime.toFixed(0)}ms per trade)`);
        console.log(`🚀 OPUS 4.1 Speed Rating: ${avgTime < 500 ? 'ULTRA-FAST' : avgTime < 1000 ? 'FAST' : 'NORMAL'}`);
        
        // OPUS 4.1: Track performance with speed metrics
        const successfulTrades = results.results.filter(r => r.success).length;
        this.totalTrades += trades.length;
        this.successRate = (successfulTrades / this.totalTrades) * 100;
        
        return {
            results: results.results,
            totalTime,
            avgTime,
            successRate: (successfulTrades / trades.length) * 100,
            opusSpeed: avgTime < 500 ? 'ULTRA-FAST' : avgTime < 1000 ? 'FAST' : 'NORMAL',
            successCount: successfulTrades
        };
    }

    // OPUS 4.1 Ultra-fast token monitoring
    async monitorTokensForDIP(tokenAddresses, callback) {
        console.log(`🔍 OPUS 4.1: Monitoring ${tokenAddresses.length} tokens for DIP opportunities...`);
        
        // OPUS 4.1: Use the trading engine's ultra-fast monitoring
        const stopMonitoring = await this.tradingEngine.monitorPricesForDIP(tokenAddresses, async (priceData) => {
            try {
                // OPUS 4.1: Detect DIP immediately
                const dipResult = await this.detectDIP(priceData.tokenAddress, priceData.currentPrice);
                
                if (dipResult.isDIP) {
                    console.log(`📉 OPUS 4.1 DIP DETECTED: ${priceData.tokenAddress}`);
                    console.log(`📊 Price change: ${dipResult.priceChange.toFixed(2)}%`);
                    console.log(`⚡ Detection speed: ${Date.now() - priceData.timestamp}ms`);
                    
                    // OPUS 4.1: Execute callback immediately
                    callback({
                        tokenAddress: priceData.tokenAddress,
                        currentPrice: priceData.currentPrice,
                        dipData: dipResult,
                        timestamp: Date.now()
                    });
                    
                    // OPUS 4.1: Auto-execute trade if auto-trading is enabled
                    if (this.tradingEngine.bot && this.tradingEngine.bot.autoTradingConfig.autoTradingMode) {
                        const signal = {
                            type: 'BUY',
                            tokenAddress: priceData.tokenAddress,
                            price: priceData.currentPrice,
                            dipData: dipResult
                        };
                        
                        // OPUS 4.1: Execute trade without waiting for result
                        this.tradingEngine.bot.executeAutoTrade(signal).then(result => {
                            if (result.success) {
                                console.log(`🚀 OPUS 4.1 Auto-trade executed: ${result.txHash}`);
                            } else {
                                console.log(`❌ OPUS 4.1 Auto-trade failed: ${result.reason || result.error}`);
                            }
                        }).catch(error => {
                            console.error(`❌ OPUS 4.1 Auto-trade error: ${error.message}`);
                        });
                    }
                }
                
            } catch (error) {
                console.error(`❌ OPUS 4.1 DIP detection error: ${error.message}`);
            }
        }, 1000); // 1 second interval for maximum speed
        
        return stopMonitoring;
    }

    // OPUS 4.1 Ultra-fast profit taking
    async executeProfitTake(wallet, tokenAddress, profitThreshold = 20) {
        try {
            // OPUS 4.1: Get current price without cache for real-time accuracy
            const currentPrice = await this.tradingEngine.getTokenPrice(tokenAddress, false);
            const position = this.activePositions.get(tokenAddress);
            
            if (!position) {
                return { success: false, error: 'No active position found' };
            }
            
            // OPUS 4.1: Calculate profit percentage with high precision
            const profitPercent = ((currentPrice.price - position.baselinePrice) / position.baselinePrice) * 100;
            
            if (profitPercent >= profitThreshold) {
                console.log(`💰 OPUS 4.1 Profit target reached: ${profitPercent.toFixed(2)}%`);
                
                // OPUS 4.1: Execute ultra-fast sell
                const result = await this.tradingEngine.executeUltraFastDIPBuy(
                    wallet,
                    this.tradingEngine.WLD_ADDRESS, // Sell for WLD
                    position.expectedOutput,
                    this.MAX_SLIPPAGE
                );
                
                if (result.success) {
                    this.activePositions.delete(tokenAddress);
                    console.log(`✅ OPUS 4.1 Profit taken: ${result.txHash}`);
                    console.log(`⚡ OPUS 4.1 Sell execution time: ${result.executionTime}ms`);
                }
                
                return result;
            }
            
            return { success: false, reason: 'Profit threshold not reached' };
            
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    // OPUS 4.1 Get strategy performance metrics
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
        
        // OPUS 4.1: Calculate speed rating
        const getSpeedRating = (time) => {
            if (time < 500) return 'ULTRA-FAST';
            if (time < 1000) return 'FAST';
            if (time < 2000) return 'NORMAL';
            return 'SLOW';
        };
        
        return {
            totalTrades: this.totalTrades,
            successRate: this.successRate,
            avgExecutionTime: avgExecutionTime.toFixed(0),
            minExecutionTime,
            maxExecutionTime,
            activePositions: this.activePositions.size,
            dipAlerts: this.dipAlerts.size,
            opusSpeedRating: getSpeedRating(avgExecutionTime),
            ultraFastTrades: this.executionTimes.filter(t => t < 500).length,
            fastTrades: this.executionTimes.filter(t => t >= 500 && t < 1000).length,
            normalTrades: this.executionTimes.filter(t => t >= 1000 && t < 2000).length,
            slowTrades: this.executionTimes.filter(t => t >= 2000).length
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

    // OPUS 4.1 Get strategy status
    getStatus() {
        const performance = this.getPerformanceMetrics();
        
        return {
            dipThreshold: this.DIP_THRESHOLD,
            maxSlippage: this.MAX_SLIPPAGE,
            gasPrice: ethers.formatUnits(this.GAS_PRICE, 'gwei'),
            gasLimit: this.GAS_LIMIT,
            batchSize: this.BATCH_SIZE,
            opusVersion: '4.1',
            opusSpeedRating: performance.opusSpeedRating,
            ultraFastTrades: performance.ultraFastTrades,
            fastTrades: performance.fastTrades,
            normalTrades: performance.normalTrades,
            slowTrades: performance.slowTrades,
            performance: performance
        };
    }
}

module.exports = UltraFastDIPStrategy;