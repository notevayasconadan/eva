const { ethers } = require('ethers');
require('dotenv').config();

async function testRPCConnection() {
    console.log('🔧 Testing RPC Connection...\n');
    
    const rpcUrl = process.env.RPC_URL || 'https://worldchain-mainnet.g.alchemy.com/public';
    const chainId = process.env.CHAIN_ID || '12345';
    
    console.log(`📡 RPC URL: ${rpcUrl}`);
    console.log(`🔗 Chain ID: ${chainId}\n`);
    
    try {
        // Create provider
        const provider = new ethers.JsonRpcProvider(rpcUrl);
        
        console.log('⏳ Connecting to RPC endpoint...');
        
        // Test basic connection
        const network = await provider.getNetwork();
        console.log(`✅ Network detected: ${network.name} (Chain ID: ${network.chainId})`);
        
        // Test block number
        const blockNumber = await provider.getBlockNumber();
        console.log(`📦 Current block: ${blockNumber}`);
        
        // Test gas price
        const gasPrice = await provider.getFeeData();
        console.log(`⛽ Gas price: ${ethers.formatUnits(gasPrice.gasPrice || 0, 'gwei')} gwei`);
        
        console.log('\n🎉 RPC connection successful!');
        
        // Test wallet connection if private key is set
        if (process.env.PRIVATE_KEY && process.env.PRIVATE_KEY !== 'your_private_key_here') {
            console.log('\n🔐 Testing wallet connection...');
            const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
            const balance = await wallet.getBalance();
            console.log(`💰 Wallet balance: ${ethers.formatEther(balance)} WLD`);
            console.log(`📍 Wallet address: ${wallet.address}`);
        } else {
            console.log('\n⚠️  No private key configured. Set PRIVATE_KEY in .env to test wallet connection.');
        }
        
    } catch (error) {
        console.error('\n❌ RPC connection failed:');
        console.error(`Error: ${error.message}`);
        
        console.log('\n🔧 Troubleshooting suggestions:');
        console.log('1. Check if the RPC URL is correct');
        console.log('2. Verify the chain ID is correct for Worldchain');
        console.log('3. Check your internet connection');
        console.log('4. Try a different RPC endpoint');
        
        // Try alternative chain IDs
        console.log('\n🔄 Testing alternative chain IDs...');
        const alternativeChainIds = ['1234', '1', '137'];
        
        for (const altChainId of alternativeChainIds) {
            try {
                console.log(`\nTesting Chain ID: ${altChainId}`);
                const altProvider = new ethers.JsonRpcProvider(rpcUrl);
                const altNetwork = await altProvider.getNetwork();
                console.log(`✅ Works with Chain ID: ${altNetwork.chainId}`);
                break;
            } catch (altError) {
                console.log(`❌ Chain ID ${altChainId} failed: ${altError.message}`);
            }
        }
    }
}

// Run the test
testRPCConnection().catch(console.error);