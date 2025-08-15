const { ethers } = require('ethers');
const EventEmitter = require('events');

// 🚀 OPUS 4.1: ULTRA-FAST DIP STRATEGY - MAXIMUM SPEED IMPLEMENTATION
class UltraFastDIPStrategy {
    constructor(tradingEngine, config = {}) {
        this.tradingEngine = tradingEngine;
        
        // OPUS 4.1: Ultra-aggressive configuration for maximum speed
        this.config = {
            dipThreshold: config.dipThreshold || 1, // 1% dip threshold for ultra-speed
            monitoringInterval: config.monitoringInterval || 10, // 10ms for ultra-speed (reduced from 250ms)
            maxSlippage: config.maxSlippage || 50, // 50% slippage for ultra-speed
            gasPrice: config.gasPrice || '2000', // 2000 gwei for ultra-priority (increased from 200)
            gasLimit: config.gasLimit || 5000000, // 5M gas limit for complex transactions
            priorityFee: config.priorityFee || '1000', // 1000 gwei priority fee (increased from 100)
            instantExecution: config.instantExecution !== false, // Always true for ultra-speed
            skipValidation: config.skipValidation !== false, // Skip all validation for speed
            parallelExecution: config.parallelExecution !== false, // Execute in parallel
            ...config
        };
        
        this.isRunning = false;
        this.monitoringTokens = new Set();
        this.priceHistory = new Map();
        this.executionStats = {
            totalExecutions: 0,
            successfulExecutions: 0,
            totalVolume: 0,
            averageExecutionTime: 0,
            fastestExecution: Infinity,
            slowestExecution: 0,
            lastExecution: null
        };
        
        // OPUS 4.1: Event emitter for real-time updates
        this.events = new EventEmitter();
        
        console.log('🚀 OPUS 4.1 ULTRA-FAST DIP STRATEGY INITIALIZED');
        console.log(`⚡ Monitoring interval: ${this.config.monitoringInterval}ms (ULTRA-SPEED)`);
        console.log(`🔥 Dip threshold: ${this.config.dipThreshold}% (ULTRA-SENSITIVE)`);
        console.log(`💨 Max slippage: ${this.config.maxSlippage}% (ULTRA-AGGRESSIVE)`);
        console.log(`⛽ Gas price: ${this.config.gasPrice} gwei (ULTRA-PRIORITY)`);
        console.log(`🚀 Instant execution: ${this.config.instantExecution}`);
        console.log(`⚡ Skip validation: ${this.config.skipValidation}`);
        console.log(`🔄 Parallel execution: ${this.config.parallelExecution}`);
    }

    // OPUS 4.1: Ultra-fast DIP detection with zero delays
    async detectDIP(tokenAddress, currentPrice) {
        const startTime = Date.now();
        
        try {
            const priceHistory = this.priceHistory.get(tokenAddress) || [];
            const now = Date.now();
            
            // OPUS 4.1: Add current price to history (minimal processing)
            priceHistory.push({
                price: currentPrice,
                timestamp: now
            });
            
            // OPUS 4.1: Keep only last 5 prices for ultra-speed
            if (priceHistory.length > 5) {
                priceHistory.splice(0, priceHistory.length - 5);
            }
            
            this.priceHistory.set(tokenAddress, priceHistory);
            
            // OPUS 4.1: Calculate price change (minimal threshold)
            if (priceHistory.length >= 2) {
                const previousPrice = priceHistory[priceHistory.length - 2].price;
                const priceChange = ((currentPrice - previousPrice) / previousPrice) * 100;
                
                // OPUS 4.1: Check for DIP with ultra-sensitive threshold
                if (priceChange <= -this.config.dipThreshold) {
                    const dipInfo = {
                        tokenAddress,
                        currentPrice,
                        previousPrice,
                        priceChange,
                        dipPercentage: Math.abs(priceChange),
                        timestamp: now,
                        detectionTime: Date.now() - startTime
                    };
                    
                    console.log(`🚀 ULTRA-FAST DIP DETECTED! ${tokenAddress}: ${priceChange.toFixed(2)}% drop in ${dipInfo.detectionTime}ms`);
                    this.events.emit('dipDetected', dipInfo);
                    
                    return dipInfo;
                }
            }
            
            return null;
            
        } catch (error) {
            console.error('OPUS 4.1 Ultra-fast DIP detection error:', error.message);
            return null;
        }
    }

    // OPUS 4.1: Ultra-fast DIP execution with maximum speed
    async executeDIPBuy(wallet, dipInfo, amountInWLD) {
        const startTime = Date.now();
        
        try {
            console.log(`🎯 Executing OPUS 4.1 ULTRA-FAST DIP Buy...`);
            console.log(`💰 Amount: ${amountInWLD} WLD`);
            console.log(`📉 Dip: ${dipInfo.dipPercentage.toFixed(2)}%`);
            console.log(`⚡ Detection time: ${dipInfo.detectionTime}ms`);
            
            // OPUS 4.1: Execute ultra-fast DIP buy with maximum slippage
            const result = await this.tradingEngine.executeUltraFastDIPBuy(
                wallet,
                dipInfo.tokenAddress,
                amountInWLD,
                this.config.maxSlippage
            );
            
            const executionTime = Date.now() - startTime;
            
            // OPUS 4.1: Update execution stats
            this.executionStats.totalExecutions++;
            this.executionStats.totalVolume += amountInWLD;
            
            if (result.success) {
                this.executionStats.successfulExecutions++;
                this.executionStats.lastExecution = {
                    ...result,
                    dipInfo,
                    executionTime
                };
                
                // OPUS 4.1: Track fastest/slowest execution times
                if (executionTime < this.executionStats.fastestExecution) {
                    this.executionStats.fastestExecution = executionTime;
                }
                if (executionTime > this.executionStats.slowestExecution) {
                    this.executionStats.slowestExecution = executionTime;
                }
                
                console.log(`✅ ULTRA-FAST DIP Buy Executed Successfully!`);
                console.log(`⚡ Execution time: ${executionTime}ms`);
                console.log(`🔥 Gas price: ${result.gasPrice} gwei`);
                console.log(`📊 TX Hash: ${result.txHash}`);
                console.log(`🚀 OPUS 4.1 Speed: ${result.opusSpeed || 'ULTRA-FAST'}`);
                
                this.events.emit('dipExecuted', {
                    ...result,
                    dipInfo,
                    executionTime
                });
            } else {
                console.log(`❌ ULTRA-FAST DIP Buy Failed: ${result.error}`);
                this.events.emit('dipFailed', {
                    ...result,
                    dipInfo,
                    executionTime
                });
            }
            
            // OPUS 4.1: Update average execution time
            this.executionStats.averageExecutionTime = 
                (this.executionStats.averageExecutionTime * (this.executionStats.totalExecutions - 1) + executionTime) / 
                this.executionStats.totalExecutions;
            
            return result;
            
        } catch (error) {
            const executionTime = Date.now() - startTime;
            console.error('OPUS 4.1 Ultra-fast DIP execution error:', error.message);
            
            this.events.emit('dipError', {
                error: error.message,
                dipInfo,
                executionTime
            });
            
            return {
                success: false,
                error: error.message,
                executionTime
            };
        }
    }

    // OPUS 4.1: Ultra-fast continuous DIP monitoring with 10ms intervals
    async startDIPMonitoring(wallet, tokenAddresses, amountInWLD) {
        if (this.isRunning) {
            console.log('⚠️ Ultra-fast DIP monitoring is already running');
            return;
        }
        
        console.log(`🚀 Starting OPUS 4.1 ULTRA-FAST DIP Monitoring...`);
        console.log(`📊 Monitoring ${tokenAddresses.length} tokens`);
        console.log(`💰 Buy amount: ${amountInWLD} WLD per DIP`);
        console.log(`⚡ Monitoring interval: ${this.config.monitoringInterval}ms (ULTRA-SPEED)`);
        
        this.isRunning = true;
        this.monitoringTokens = new Set(tokenAddresses);
        
        const monitor = async () => {
            if (!this.isRunning) return;
            
            try {
                // OPUS 4.1: Get all prices in parallel with zero delays
                const pricePromises = Array.from(this.monitoringTokens).map(async (tokenAddress) => {
                    try {
                        const priceData = await this.tradingEngine.getTokenPrice(tokenAddress);
                        return { tokenAddress, price: priceData.price };
                    } catch (error) {
                        return { tokenAddress, error: error.message };
                    }
                });
                
                const prices = await Promise.all(pricePromises);
                
                // OPUS 4.1: Process prices and detect DIPs immediately
                const dipPromises = [];
                
                for (const priceData of prices) {
                    if (priceData.price && !priceData.error) {
                        const dipInfo = await this.detectDIP(priceData.tokenAddress, priceData.price);
                        
                        if (dipInfo) {
                            // OPUS 4.1: Execute DIP buy immediately or in parallel
                            if (this.config.parallelExecution) {
                                dipPromises.push(this.executeDIPBuy(wallet, dipInfo, amountInWLD));
                            } else {
                                await this.executeDIPBuy(wallet, dipInfo, amountInWLD);
                            }
                        }
                    }
                }
                
                // OPUS 4.1: Wait for parallel executions if enabled
                if (this.config.parallelExecution && dipPromises.length > 0) {
                    await Promise.all(dipPromises);
                }
                
            } catch (error) {
                console.error('OPUS 4.1 Ultra-fast DIP monitoring error:', error.message);
            }
        };
        
        // OPUS 4.1: Execute immediately and set ultra-fast interval
        await monitor();
        this.monitoringInterval = setInterval(monitor, this.config.monitoringInterval);
        
        this.events.emit('monitoringStarted', {
            tokenAddresses: Array.from(this.monitoringTokens),
            config: this.config
        });
        
        return this.monitoringInterval;
    }

    // OPUS 4.1: Stop DIP monitoring
    stopDIPMonitoring() {
        if (!this.isRunning) {
            console.log('⚠️ Ultra-fast DIP monitoring is not running');
            return;
        }
        
        console.log('🛑 Stopping OPUS 4.1 Ultra-Fast DIP Monitoring...');
        
        this.isRunning = false;
        if (this.monitoringInterval) {
            clearInterval(this.monitoringInterval);
            this.monitoringInterval = null;
        }
        
        this.events.emit('monitoringStopped', {
            stats: this.executionStats
        });
    }

    // OPUS 4.1: Ultra-fast batch DIP execution
    async executeBatchDIPBuys(wallet, dipInfos, amountInWLD) {
        const startTime = Date.now();
        
        console.log(`🚀 Executing OPUS 4.1 ULTRA-FAST Batch DIP Buys...`);
        console.log(`📊 DIPs to execute: ${dipInfos.length}`);
        
        // OPUS 4.1: Execute all DIP buys in parallel for maximum speed
        const executionPromises = dipInfos.map(dipInfo => 
            this.executeDIPBuy(wallet, dipInfo, amountInWLD)
        );
        
        const results = await Promise.all(executionPromises);
        const totalTime = Date.now() - startTime;
        
        const successCount = results.filter(r => r.success).length;
        
        console.log(`✅ ULTRA-FAST Batch DIP execution completed`);
        console.log(`📊 Success: ${successCount}/${dipInfos.length}`);
        console.log(`⚡ Total time: ${totalTime}ms`);
        console.log(`⚡ Average time: ${totalTime / dipInfos.length}ms`);
        
        return {
            results,
            totalTime,
            successCount,
            failureCount: dipInfos.length - successCount
        };
    }

    // OPUS 4.1: Get execution statistics
    getExecutionStats() {
        return {
            ...this.executionStats,
            successRate: this.executionStats.totalExecutions > 0 ? 
                (this.executionStats.successfulExecutions / this.executionStats.totalExecutions) * 100 : 0,
            isRunning: this.isRunning,
            monitoringTokens: Array.from(this.monitoringTokens),
            config: this.config
        };
    }

    // OPUS 4.1: Add token to monitoring
    addTokenToMonitoring(tokenAddress) {
        this.monitoringTokens.add(tokenAddress);
        console.log(`📊 Added ${tokenAddress} to ultra-fast DIP monitoring`);
        this.events.emit('tokenAdded', tokenAddress);
    }

    // OPUS 4.1: Remove token from monitoring
    removeTokenFromMonitoring(tokenAddress) {
        this.monitoringTokens.delete(tokenAddress);
        console.log(`📊 Removed ${tokenAddress} from ultra-fast DIP monitoring`);
        this.events.emit('tokenRemoved', tokenAddress);
    }

    // OPUS 4.1: Update configuration
    updateConfig(newConfig) {
        this.config = { ...this.config, ...newConfig };
        console.log('⚙️ OPUS 4.1 Ultra-Fast DIP Strategy configuration updated');
        this.events.emit('configUpdated', this.config);
    }

    // OPUS 4.1: Instant DIP execution (bypasses all monitoring)
    async executeInstantDIP(wallet, tokenAddress, amountInWLD) {
        const startTime = Date.now();
        
        try {
            console.log(`🚀 OPUS 4.1: Executing INSTANT DIP buy for ${tokenAddress}`);
            console.log(`⚡ Bypassing all monitoring delays for maximum speed`);
            
            // OPUS 4.1: Execute ultra-fast DIP buy immediately
            const result = await this.tradingEngine.executeUltraFastDIPBuy(
                wallet,
                tokenAddress,
                amountInWLD,
                this.config.maxSlippage
            );
            
            const totalTime = Date.now() - startTime;
            
            console.log(`🎯 OPUS 4.1 INSTANT DIP EXECUTED in ${totalTime}ms`);
            console.log(`🚀 OPUS 4.1 Speed: ${totalTime < 50 ? 'INSTANT' : totalTime < 100 ? 'ULTRA-FAST' : 'FAST'}`);
            
            return {
                ...result,
                dipDetected: true,
                totalTime,
                opusSpeed: totalTime < 50 ? 'INSTANT' : totalTime < 100 ? 'ULTRA-FAST' : 'FAST'
            };
            
        } catch (error) {
            const totalTime = Date.now() - startTime;
            return {
                success: false,
                error: error.message,
                totalTime
            };
        }
    }
}

// OPUS 4.1: Ultra-fast Strategy Manager
class UltraFastStrategyManager {
    constructor(tradingEngine) {
        this.tradingEngine = tradingEngine;
        this.strategies = new Map();
        this.activeStrategies = new Set();
        this.events = new EventEmitter();
        
        console.log('🚀 OPUS 4.1 ULTRA-FAST STRATEGY MANAGER INITIALIZED');
    }

    // OPUS 4.1: Create ultra-fast DIP strategy
    createUltraFastDIPStrategy(strategyId, config = {}) {
        const strategy = new UltraFastDIPStrategy(this.tradingEngine, config);
        this.strategies.set(strategyId, strategy);
        
        console.log(`📊 Created OPUS 4.1 Ultra-Fast DIP Strategy: ${strategyId}`);
        return strategy;
    }

    // OPUS 4.1: Get strategy
    getStrategy(strategyId) {
        return this.strategies.get(strategyId);
    }

    // OPUS 4.1: Start ultra-fast strategy
    async startUltraFastStrategy(strategyId, wallet, tokenAddresses, amountInWLD) {
        const strategy = this.getStrategy(strategyId);
        if (!strategy) {
            throw new Error(`Ultra-fast strategy ${strategyId} not found`);
        }
        
        await strategy.startDIPMonitoring(wallet, tokenAddresses, amountInWLD);
        this.activeStrategies.add(strategyId);
        
        console.log(`🚀 Started OPUS 4.1 Ultra-Fast Strategy: ${strategyId}`);
        this.events.emit('strategyStarted', strategyId);
    }

    // OPUS 4.1: Stop strategy
    stopStrategy(strategyId) {
        const strategy = this.getStrategy(strategyId);
        if (!strategy) {
            throw new Error(`Strategy ${strategyId} not found`);
        }
        
        strategy.stopDIPMonitoring();
        this.activeStrategies.delete(strategyId);
        
        console.log(`🛑 Stopped OPUS 4.1 Ultra-Fast Strategy: ${strategyId}`);
        this.events.emit('strategyStopped', strategyId);
    }

    // OPUS 4.1: Get all strategies status
    getStrategiesStatus() {
        const status = {};
        
        for (const [strategyId, strategy] of this.strategies) {
            status[strategyId] = {
                type: 'Ultra-Fast DIP',
                isActive: this.activeStrategies.has(strategyId),
                stats: strategy.getExecutionStats(),
                config: strategy.config
            };
        }
        
        return status;
    }

    // OPUS 4.1: Stop all strategies
    stopAllStrategies() {
        console.log('🛑 Stopping all OPUS 4.1 ultra-fast strategies...');
        
        for (const strategyId of this.activeStrategies) {
            this.stopStrategy(strategyId);
        }
        
        console.log('✅ All ultra-fast strategies stopped');
    }
}

module.exports = {
    UltraFastDIPStrategy,
    UltraFastStrategyManager
};