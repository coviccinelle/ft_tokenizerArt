#!/bin/bash

# 🎨 42 NFT - Simple Management Script
# One script to rule them all!

set -e

show_help() {
    echo "🎨 42 NFT Management"
    echo "==================="
    echo ""
    echo "Usage: ./manage.sh <command>"
    echo ""
    echo "Commands:"
    echo "  deploy      Deploy contract to Sepolia"
    echo "  test        Run contract tests"
    echo "  update      Update IPFS hash on contract"
    echo "  mint        Mint NFT (beautiful or bonus)"
    echo "  server      Start web server"
    echo "  status      Show current status"
    echo ""
    echo "Examples:"
    echo "  ./manage.sh deploy"
    echo "  ./manage.sh test"
    echo "  ./manage.sh update"
    echo "  ./manage.sh mint beautiful 0x123..."
    echo "  ./manage.sh server"
}

check_env() {
    if [ ! -f ".env" ]; then
        echo "❌ .env file not found"
        echo "Copy .env.example and fill in your values"
        exit 1
    fi
    source .env
}

deploy() {
    echo "🚀 Deploying contract..."
    cd code
    forge script ../deployment/Deploy.s.sol:DeployScript --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
    cd ..
}

run_tests() {
    echo "🧪 Running contract tests..."
    cd code
    forge test -vv
    cd ..
}

update_ipfs() {
    echo "🔄 Updating IPFS hash..."
    cd code
    forge script ../deployment/UpdateIPFS.s.sol:UpdateIPFSScript --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
    cd ..
}

mint_nft() {
    TYPE=$1
    ADDRESS=$2
    
    if [ -z "$TYPE" ] || [ -z "$ADDRESS" ]; then
        echo "Usage: ./manage.sh mint <beautiful|bonus> <address>"
        exit 1
    fi
    
    echo "🎨 Minting $TYPE NFT to $ADDRESS..."
    cd code
    forge script ../mint/Mint.s.sol:MintScript --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast -- $TYPE $ADDRESS
    cd ..
}

start_server() {
    echo "🌐 Starting web server..."
    echo "Open: http://localhost:3000/native-mint.html"
    cd web
    python3 -m http.server 3000
}

show_status() {
    echo "📊 Project Status"
    echo "================"
    echo ""
    echo "Contract: 0xFcE8134d569F41Fb05b52A081B9197840148caaf"
    echo "Network: Sepolia"
    echo "IPFS: bafybeifuat6mqtsgaotpz2cdw6botsxdgggaicflcrqxgentiic5kec6ze"
    echo ""
    echo "Files:"
    echo "  Beautiful SVGs: $(find SVGs/beautiful -name '*.svg' 2>/dev/null | wc -l || echo '0')"
    echo "  Web interface: $([ -f web/native-mint.html ] && echo '✅' || echo '❌')"
    echo "  Contract: $([ -f code/src/Token42NFT.sol ] && echo '✅' || echo '❌')"
}

# Main
case "$1" in
    deploy)
        check_env
        deploy
        ;;
    test)
        run_tests
        ;;
    update)
        check_env
        update_ipfs
        ;;
    mint)
        check_env
        mint_nft "$2" "$3"
        ;;
    server)
        start_server
        ;;
    status)
        show_status
        ;;
    *)
        show_help
        ;;
esac
