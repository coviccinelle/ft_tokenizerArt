#!/bin/bash

# 🚀 Token42NFT Deployment Script
# This script deploys the NFT contract to Ethereum Sepolia testnet

echo "🚀 Deploying 42 Art NFT Contract..."

# Check if we're in the right directory
if [ ! -f "hardhat.config.js" ]; then
    echo "❌ Error: Must run from the code/ directory"
    echo "💡 Run: cd code/ && ./deploy.sh"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found"
    echo "💡 Copy .env.example to .env and fill in your keys"
    exit 1
fi

cd code/

# Install dependencies if not already installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Compile contracts
echo "🔨 Compiling contracts..."
npm run compile

# Deploy contract
echo "🔨 Deploying to BSC Testnet..."
npm run deploy

echo "✅ Deployment complete!"
echo "📝 Check deployment/ folder for contract address"
echo "🌐 Update web/index.html with the new contract address"
