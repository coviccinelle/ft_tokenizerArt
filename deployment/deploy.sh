#!/bin/bash

# Simple deployment script for Token42NFT
echo "🚀 Deploying Token42NFT Contract"
echo "================================"

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if .env file exists in project root
if [ ! -f "$PROJECT_ROOT/.env" ]; then
    echo "❌ .env file not found in project root. Please create one with:"
    echo "RPC=https://your_rpc_url"
    echo "PRIVATE_KEY=0xYOUR_PRIVATE_KEY"
    exit 1
fi

# Source environment variables
source "$PROJECT_ROOT/.env"

# Check required variables
if [ -z "$RPC" ] || [ -z "$PRIVATE_KEY" ]; then
    echo "❌ Missing required environment variables"
    echo "Please set RPC and PRIVATE_KEY in .env file"
    exit 1
fi

echo "🔗 Network: $RPC"
echo "📁 Working directory: $(pwd)"

# Navigate to code directory
cd "$PROJECT_ROOT/code"

# Build the contract
echo "🔨 Building contract..."
forge build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful"

# Deploy the contract
echo "🚀 Deploying contract..."
forge script "$PROJECT_ROOT/deployment/Deploy.s.sol" --rpc-url $RPC --private-key 0x$PRIVATE_KEY --broadcast

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed"
    exit 1
fi

echo "✅ Deployment successful!"
echo ""
echo "📋 Next steps:"
echo "1. Copy the deployed contract address"
echo "2. Add CONTRACT_ADDRESS=0xYourAddress to .env file"
echo "3. Upload SVGs to IPFS using $PROJECT_ROOT/scripts/upload-to-ipfs.sh"
echo "4. Set IPFS hash on contract"
echo "5. Update CONTRACT_ADDRESS in $PROJECT_ROOT/web/simple.html"
