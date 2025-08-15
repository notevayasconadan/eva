// OPUS 4.1 Ultra-Fast DIP Trading Configuration
// Optimized for maximum speed and efficiency

module.exports = {
    // OPUS 4.1 Core Settings
    OPUS_VERSION: '4.1',
    OPUS_MODE: 'ULTRA_FAST',
    
    // Network Configuration
    NETWORK: {
        RPC_URL: 'https://worldchain-mainnet.g.alchemy.com/public',
        CHAIN_ID: 480,
        NETWORK_NAME: 'worldchain',
        BLOCK_TIME: 2, // 2 seconds
        CONFIRMATION_BLOCKS: 1 // Single block confirmation for speed
    },
    
    // OPUS 4.1 DIP Strategy Settings
    DIP_STRATEGY: {
        THRESHOLD: 5, // 5% price drop triggers DIP buy
        MAX_SLIPPAGE: 15, // 15% slippage for ultra-fast execution
        BATCH_SIZE: 10, // Execute up to 10 trades simultaneously
        RETRY_ATTEMPTS: 1, // Minimal retries for speed
        CONFIRMATION_TIMEOUT: 5000, // 5 second timeout
        PRICE_MONITORING_INTERVAL: 1000, // 1 second monitoring
        PROFIT_THRESHOLD: 20, // 20% profit target
        STOP_LOSS_THRESHOLD: 10 // 10% stop loss
    },
    
    // OPUS 4.1 Gas Optimization
    GAS_OPTIMIZATION: {
        ULTRA_FAST_GAS_PRICE: '100', // 100 gwei for priority
        FAST_GAS_PRICE: '50', // 50 gwei for normal speed
        GAS_LIMIT: 800000, // High gas limit for complex transactions
        MAX_FEE_PER_GAS: '100', // 100 gwei max fee
        MAX_PRIORITY_FEE: '50', // 50 gwei priority fee
        GAS_BUFFER: 20 // 20% gas buffer
    },
    
    // OPUS 4.1 Speed Settings
    SPEED_SETTINGS: {
        ULTRA_FAST_THRESHOLD: 500, // < 500ms = ULTRA-FAST
        FAST_THRESHOLD: 1000, // < 1000ms = FAST
        NORMAL_THRESHOLD: 2000, // < 2000ms = NORMAL
        SLOW_THRESHOLD: 2000 // >= 2000ms = SLOW
    },
    
    // OPUS 4.1 Trading Parameters
    TRADING_PARAMS: {
        MIN_TRADE_AMOUNT: 0.01, // Minimum 0.01 WLD
        MAX_TRADE_AMOUNT: 10, // Maximum 10 WLD
        DEFAULT_TRADE_AMOUNT: 0.1, // Default 0.1 WLD
        POSITION_SIZING: {
            SMALL: 0.05, // 0.05 WLD for small positions
            MEDIUM: 0.1, // 0.1 WLD for medium positions
            LARGE: 0.5, // 0.5 WLD for large positions
            MAX: 1.0 // 1.0 WLD maximum per trade
        }
    },
    
    // OPUS 4.1 Risk Management
    RISK_MANAGEMENT: {
        MAX_DAILY_TRADES: 50, // Maximum 50 trades per day
        MAX_DAILY_LOSS: 5, // Maximum 5% daily loss
        MAX_POSITION_SIZE: 10, // Maximum 10% of portfolio per position
        DIVERSIFICATION: {
            MAX_TOKENS_PER_SECTOR: 3, // Maximum 3 tokens per sector
            MIN_CORRELATION: 0.7, // Minimum correlation threshold
            REBALANCE_INTERVAL: 3600000 // Rebalance every hour
        }
    },
    
    // OPUS 4.1 Performance Tracking
    PERFORMANCE_TRACKING: {
        METRICS_INTERVAL: 60000, // Update metrics every minute
        LOG_LEVEL: 'INFO', // INFO, DEBUG, ERROR
        SAVE_TRADES: true, // Save all trades to database
        ANALYTICS: {
            TRACK_EXECUTION_TIME: true,
            TRACK_SLIPPAGE: true,
            TRACK_GAS_USAGE: true,
            TRACK_SUCCESS_RATE: true
        }
    },
    
    // OPUS 4.1 Advanced Features
    ADVANCED_FEATURES: {
        PARALLEL_EXECUTION: true, // Execute trades in parallel
        PRE_APPROVAL: true, // Pre-approve tokens for speed
        SMART_ROUTING: true, // Use optimal trading routes
        LIQUIDITY_CHECK: true, // Check liquidity before trading
        PRICE_IMPACT_ANALYSIS: true, // Analyze price impact
        ARBITRAGE_DETECTION: false, // Disable arbitrage for DIP focus
        FRONTRUNNING_PROTECTION: true // Protect against frontrunning
    },
    
    // OPUS 4.1 Monitoring and Alerts
    MONITORING: {
        ENABLE_ALERTS: true,
        ALERT_CHANNELS: ['console', 'telegram'],
        ALERT_THRESHOLDS: {
            EXECUTION_TIME: 2000, // Alert if execution > 2s
            SLIPPAGE: 20, // Alert if slippage > 20%
            GAS_PRICE: 150, // Alert if gas > 150 gwei
            ERROR_RATE: 10 // Alert if error rate > 10%
        }
    },
    
    // OPUS 4.1 Emergency Controls
    EMERGENCY_CONTROLS: {
        EMERGENCY_STOP: true, // Enable emergency stop
        MAX_CONCURRENT_TRADES: 5, // Maximum 5 concurrent trades
        CIRCUIT_BREAKER: {
            ENABLED: true,
            LOSS_THRESHOLD: 5, // Stop if 5% loss in 1 hour
            TIME_WINDOW: 3600000 // 1 hour window
        }
    },
    
    // OPUS 4.1 Fee Optimization
    FEE_OPTIMIZATION: {
        PREFERRED_FEE_TIER: 3000, // 0.3% fee tier
        FALLBACK_FEE_TIERS: [500, 10000], // 0.05% and 1% as fallbacks
        MIN_LIQUIDITY_THRESHOLD: 1000, // Minimum $1000 liquidity
        PRICE_IMPACT_THRESHOLD: 5 // Maximum 5% price impact
    },
    
    // OPUS 4.1 Cache Settings
    CACHE_SETTINGS: {
        PRICE_CACHE_DURATION: 5000, // 5 seconds cache
        LIQUIDITY_CACHE_DURATION: 30000, // 30 seconds cache
        GAS_CACHE_DURATION: 10000, // 10 seconds cache
        CLEAR_CACHE_ON_ERROR: true // Clear cache on errors
    },
    
    // OPUS 4.1 Testing and Development
    DEVELOPMENT: {
        TEST_MODE: false, // Set to true for testing
        MOCK_TRADES: false, // Set to true for mock trading
        DEBUG_MODE: false, // Set to true for debug output
        LOG_TRADES: true, // Log all trades
        SIMULATION_MODE: false // Set to true for simulation
    }
};