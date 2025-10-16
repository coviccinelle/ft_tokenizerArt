#!/bin/bash

# Simple minting script for Token42NFT
echo "🎨 Token42NFT Minting Script"
echo "==========================="

# Check parameters
if [ $# -ne 2 ]; then
    echo "Usage: $0 <CONTRACT_ADDRESS> <beautiful|bonus>"
    echo ""
    echo "Examples:"
    echo "  $0 0x123... beautiful    # Mint beautiful SVG from IPFS"
    echo "  $0 0x123... bonus        # Mint bonus SVG onchain"
    exit 1
fi

CONTRACT_ADDRESS=$1
MINT_TYPE=$2

# Validate mint type
if [ "$MINT_TYPE" != "beautiful" ] && [ "$MINT_TYPE" != "bonus" ]; then
    echo "❌ Invalid mint type. Use 'beautiful' or 'bonus'"
    exit 1
fi

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if .env file exists in project root
if [ ! -f "$PROJECT_ROOT/.env" ]; then
    echo "❌ .env file not found in project root. Please create one with:"
    echo "RPC=https://your_rpc_url"
    echo "PRIVATE_KEY=0xYOUR_PRIVATE_KEY"
    echo "RECIPIENT_ADDRESS=0xRECIPIENT_ADDRESS"
    exit 1
fi

# Source environment variables
source "$PROJECT_ROOT/.env"

# Check required variables
if [ -z "$RPC" ] || [ -z "$PRIVATE_KEY" ] || [ -z "$RECIPIENT_ADDRESS" ]; then
    echo "❌ Missing required environment variables"
    echo "Please set RPC, PRIVATE_KEY, and RECIPIENT_ADDRESS in .env file"
    exit 1
fi

echo "🔗 Network: $RPC"
echo "📄 Contract: $CONTRACT_ADDRESS"
echo "🎨 Mint Type: $MINT_TYPE"
echo "👤 Recipient: $RECIPIENT_ADDRESS"
echo ""

# Export variables for forge script
export CONTRACT_ADDRESS
export MINT_TYPE

# Navigate to code directory
cd ../code

# Run minting script
echo "🚀 Minting NFT..."

if [ "$MINT_TYPE" = "beautiful" ]; then
    cast send $CONTRACT_ADDRESS "mintBeautiful(address)" $RECIPIENT_ADDRESS --rpc-url $RPC --private-key $PRIVATE_KEY
else
    cast send $CONTRACT_ADDRESS "mintBonus(address)" $RECIPIENT_ADDRESS --rpc-url $RPC --private-key $PRIVATE_KEY
fi

if [ $? -eq 0 ]; then
    echo "✅ NFT minted successfully!"
    echo ""
    echo "🔍 Check your wallet or use:"
    echo "cast call $CONTRACT_ADDRESS \"totalSupply()\" --rpc-url $RPC"
else
    echo "❌ Minting failed"
    exit 1
fi
