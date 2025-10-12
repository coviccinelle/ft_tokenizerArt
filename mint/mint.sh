#!/bin/bash

# 🎨 Token42NFT Minting Script  
# This script mints your NFT after contract deployment

echo "🎨 Starting NFT minting..."

# Check if we're in the right directory
if [ ! -f "../code/hardhat.config.js" ]; then
    echo "❌ Error: Must run from the mint/ directory"
    echo "💡 Run: cd mint/ && ./mint.sh"
    exit 1
fi

# Check if contract is deployed
NETWORK=${1:-sepolia}
DEPLOYMENT_FILE="deployment-${NETWORK}.json"

if [ ! -f "../deployment/${DEPLOYMENT_FILE}" ]; then
    echo "❌ Error: Contract not deployed to ${NETWORK}"
    echo "💡 Deploy first: cd ../deployment && ./deploy.sh"
    exit 1
fi

# Check if metadata URI is updated
if grep -q "QmYourMetadataHashHere" scripts/mint.js; then
    echo "❌ Error: Please update metadata URI in scripts/mint.js"
    echo "💡 Replace 'QmYourMetadataHashHere' with your actual IPFS hash"
    exit 1
fi

# Mint the NFT
echo "🎯 Minting NFT on ${NETWORK}..."
cd ../code
npx hardhat run ../mint/scripts/mint.js --network ${NETWORK}

echo "✅ Minting complete!"
echo "📋 Check mint/ folder for NFT details"
