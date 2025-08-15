const { ethers } = require('ethers');

// Test different RPC URLs and chain IDs for Worldchain
const rpcTests = [
    {
        name: "Alchemy Worldchain",
        url: "https://worldchain-mainnet.g.alchemy.com/public",
        chainId: 480
    },
    {
        name: "Alchemy Worldchain (Alternative)",
        url: "https://worldchain-mainnet.g.alchemy.com/public",
        chainId: 12345
    },
    {
        name: "DRPC Worldchain",
        url: "https://worldchain.drpc.org",
        chainId: 480
    },
    {
        name: "DRPC Worldchain (Alternative)",
        url: "https://worldchain.drpc.org",
        chainId: 12345
    },
    {
        name: "Official Worldchain RPC",
        url: "https://rpc.worldchain.org",
        chainId: 480
    },
    {
        name: "Official Worldchain RPC (Alternative)",
        url: "https://rpc.worldchain.org",
        chainId: 12345
    },
    {
        name: "PublicNode Worldchain",
        url: "https://worldchain-rpc.publicnode.com",
        chainId: 480
    },
    {
        name: "PublicNode Worldchain (Alternative)",
        url: "https://worldchain-rpc.publicnode.com",
        chainId: 12345
    },
    {
        name: "Ankr Worldchain",
        url: "https://rpc.ankr.com/worldchain",
        chainId: 480
    },
    {
        name: "Ankr Worldchain (Alternative)",
        url: "https://rpc.ankr.com/worldchain",
        chainId: 12345
    }
];

async function testRPCConnection(test) {
    console.log(`\n🔧 Testing: ${test.name}`);
    console.log(`📡 URL: ${test.url}`);
    console.log(`🔗 Chain ID: ${test.chainId}`);
    
    try {
        const provider = new ethers.JsonRpcProvider(test.url);
        
        // Test basic connection
        const network = await provider.getNetwork();
        console.log(`✅ Network detected: ${network.name} (Chain ID: ${network.chainId})`);
        
        // Test block number
        const blockNumber = await provider.getBlockNumber();
        console.log(`📦 Current block: ${blockNumber}`);
        
        // Test gas price
        const gasPrice = await provider.getFeeData();
        console.log(`⛽ Gas price: ${ethers.formatUnits(gasPrice.gasPrice || 0, 'gwei')} gwei`);
        
        // Test if chain ID matches expected
        if (network.chainId === BigInt(test.chainId)) {
            console.log(`🎯 Chain ID MATCH: Expected ${test.chainId}, Got ${network.chainId}`);
            return { success: true, network: network, provider: provider };
        } else {
            console.log(`⚠️  Chain ID MISMATCH: Expected ${test.chainId}, Got ${network.chainId}`);
            return { success: false, network: network, provider: provider };
        }
        
    } catch (error) {
        console.log(`❌ Connection failed: ${error.message}`);
        return { success: false, error: error.message };
    }
}

async function main() {
    console.log('🌙 ALGORITMIT MoonFixed RPC Diagnostic Tool');
    console.log('🔍 Testing Worldchain RPC endpoints...\n');
    
    const results = [];
    
    for (const test of rpcTests) {
        const result = await testRPCConnection(test);
        results.push({
            test: test,
            result: result
        });
        
        // Small delay between tests
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    console.log('\n📊 Test Results Summary:');
    console.log('========================');
    
    const workingConnections = results.filter(r => r.result.success);
    const partialConnections = results.filter(r => r.result.provider && !r.result.success);
    const failedConnections = results.filter(r => !r.result.provider);
    
    console.log(`✅ Working connections: ${workingConnections.length}`);
    console.log(`⚠️  Partial connections: ${partialConnections.length}`);
    console.log(`❌ Failed connections: ${failedConnections.length}`);
    
    if (workingConnections.length > 0) {
        console.log('\n🎯 RECOMMENDED CONFIGURATION:');
        console.log('============================');
        const best = workingConnections[0];
        console.log(`RPC_URL=${best.test.url}`);
        console.log(`CHAIN_ID=${best.test.chainId}`);
        console.log(`NETWORK_NAME=${best.result.network.name}`);
        
        console.log('\n📝 Update your .env file with:');
        console.log(`RPC_URL=${best.test.url}`);
        console.log(`CHAIN_ID=${best.test.chainId}`);
    } else if (partialConnections.length > 0) {
        console.log('\n⚠️  PARTIAL CONNECTIONS (wrong chain ID):');
        console.log('==========================================');
        for (const conn of partialConnections) {
            console.log(`${conn.test.name}: ${conn.test.url} (Got Chain ID: ${conn.result.network.chainId})`);
        }
    }
    
    console.log('\n🔧 Troubleshooting:');
    console.log('1. Check your internet connection');
    console.log('2. Try a different RPC endpoint');
    console.log('3. Verify the correct chain ID for Worldchain');
    console.log('4. Check if the RPC service is available');
}

main().catch(console.error);