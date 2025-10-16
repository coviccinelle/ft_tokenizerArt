#!/bin/bash

echo "🔗 Setting IPFS Hash on Smart Contract"
echo "====================================="

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found"
    exit 1
fi

# Source environment variables
source .env

# Check required variables
if [ -z "$IPFS_HASH" ] || [ "$IPFS_HASH" = "QmYourIPFSHashHere" ]; then
    echo "❌ Please set your IPFS_HASH in the .env file"
    echo "Get it from your Pinata dashboard and update .env:"
    echo "IPFS_HASH=QmYourActualHashHere"
    exit 1
fi

if [ -z "$CONTRACT_ADDRESS" ] || [ -z "$RPC" ] || [ -z "$PRIVATE_KEY" ]; then
    echo "❌ Missing contract configuration in .env file"
    exit 1
fi

echo "📋 IPFS Hash: $IPFS_HASH"
echo "🏠 Contract: $CONTRACT_ADDRESS"
echo "🌐 Network: $RPC"

# Test the gateway URL
echo "🧪 Testing IPFS gateway..."
GATEWAY_URL="https://gateway.pinata.cloud/ipfs/$IPFS_HASH"
echo "🔗 Gateway URL: $GATEWAY_URL"

# Set the IPFS hash on the contract
echo "📤 Setting IPFS hash on contract..."
cast send $CONTRACT_ADDRESS "setIPFSHash(string)" "$IPFS_HASH" \
    --rpc-url $RPC \
    --private-key 0x$PRIVATE_KEY

if [ $? -eq 0 ]; then
    echo "✅ IPFS hash set successfully!"
    echo ""
    echo "🎉 Your beautiful NFTs are now connected to IPFS!"
    echo "🌐 Base URL: https://gateway.pinata.cloud/ipfs/$IPFS_HASH/"
    echo ""
    echo "📋 Individual file URLs will be:"
    echo "- 42NFT_1.svg: https://gateway.pinata.cloud/ipfs/$IPFS_HASH/42NFT_1.svg"
    echo "- 42NFT_2.svg: https://gateway.pinata.cloud/ipfs/$IPFS_HASH/42NFT_2.svg"
    echo "- ... and so on"
    echo ""
    echo "🚀 Now you can mint beautiful NFTs with:"
    echo "./mint/mint.sh $CONTRACT_ADDRESS beautiful"
else
    echo "❌ Failed to set IPFS hash on contract"
    exit 1
fi
