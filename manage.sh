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
    echo "  show_status Alias for status"
    echo "  setup       Install Foundry and bootstrap the project"
    echo ""
    echo "Examples:"
    echo "  ./manage.sh setup"
    echo "  ./manage.sh deploy"
    echo "  ./manage.sh test"
    echo "  ./manage.sh update"
    echo "  ./manage.sh mint beautiful reipfsAddress 0xRECIPIENT_ADDRESS"
    echo "  ./manage.sh server"
}

check_env() {
    if [ ! -f ".env" ]; then
        echo "❌ .env file not found"
        echo "Copy .env.example and fill in your values"
        exit 1
    fi
    source .env
    # Write env for web UI
    write_web_env
}

# Write a small JSON file consumed by the static web UI (web/env.json)
write_web_env() {
    # Ensure web folder exists
    mkdir -p web
    cat > web/env.json <<EOF
{
  "CONTRACT_ADDRESS": "${CONTRACT_ADDRESS}"
}
EOF
}

deploy() {
    echo "🚀 Deploying contract..."
    cd code
    forge script ../deployment/Deploy.s.sol:DeployScript --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
    cd ..
}

test() {
    echo "🧪 Running contract tests..."
    # Tests are run from the 'code' foundry project
    if [ -d "code" ]; then
        (cd code && forge test -vv)
    else
        echo "❌ 'code' directory not found. Cannot run 'forge test'."
        return 1
    fi
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
    
    # Validate input
    if [ -z "$PRIVATE_KEY" ] || [[ "$PRIVATE_KEY" == *"your"* ]] ; then
        echo "❌ PRIVATE_KEY missing or placeholder in .env. Please set PRIVATE_KEY before minting."
        exit 1
    fi

    if [[ "$TYPE" != "beautiful" && "$TYPE" != "bonus" ]]; then
        echo "❌ Invalid mint type: $TYPE. Expected 'beautiful' or 'bonus'."
        exit 1
    fi

    if [ -z "$CONTRACT_ADDRESS" ] || [[ "$CONTRACT_ADDRESS" == *"your"* ]] || [[ "$CONTRACT_ADDRESS" == "0x0000000000000000000000000000000000000000" ]]; then
        echo "❌ CONTRACT_ADDRESS missing or placeholder in .env. Please set CONTRACT_ADDRESS to the deployed contract address before minting."
        exit 1
    fi

    echo "🎨 Minting $TYPE NFT to $ADDRESS..."
    cd code
    # Export recipient and mint type so the script can read them via vm.env*(); forward PRIVATE_KEY via env as well
    RECIPIENT="$ADDRESS" MINT_TYPE="$TYPE" PRIVATE_KEY="$PRIVATE_KEY" SEPOLIA_RPC_URL="$SEPOLIA_RPC_URL" CONTRACT_ADDRESS="$CONTRACT_ADDRESS" forge script ../mint/Mint.s.sol:MintScript --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
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
    echo "Contract: ${CONTRACT_ADDRESS}"
    echo "Network: Sepolia"
    echo "IPFS: bafybeifuat6mqtsgaotpz2cdw6botsxdgggaicflcrqxgentiic5kec6ze"
    echo ""
    echo "Files:"
    echo "  Beautiful SVGs: $(find SVGs/beautiful -name '*.svg' 2>/dev/null | wc -l || echo '0')"
    echo "  Web interface: $([ -f web/native-mint.html ] && echo '✅' || echo '❌')"
    echo "  Contract: $([ -f code/src/Token42NFT.sol ] && echo '✅' || echo '❌')"
}

setup() {
    echo "🔧 Project setup and bootstrap"

    # Create .env from example if missing
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
            echo "Created .env from .env.example; please review/update .env with real values"
        else
            echo "No .env.example found; please create a .env file with required variables"
        fi
    fi

    # Install Foundry if missing
    if ! command -v forge >/dev/null 2>&1; then
        echo "Installing Foundry (foundryup)..."
        curl -L https://foundry.paradigm.xyz | bash

        # Try to source common zsh files so new PATH is available in this session
        if [ -f "$HOME/.zshenv" ]; then
            # shellcheck disable=SC1090
            source "$HOME/.zshenv" || true
        elif [ -f "$HOME/.zshrc" ]; then
            # shellcheck disable=SC1090
            source "$HOME/.zshrc" || true
        fi

        # Install/update toolchain
        foundryup || true
    else
        echo "Foundry appears installed: $(forge --version 2>/dev/null || echo 'unknown')"
        echo "Running 'foundryup' to ensure toolchain is up-to-date"
        foundryup || true
    fi

    # Install forge dependencies and build contracts
    if [ -d "code" ]; then
        echo "Installing required forge libraries and building the project in code/"
        # Install common dependencies only if they're not present to avoid re-cloning
        if [ ! -d "code/lib/forge-std" ] || [ ! -d "code/lib/openzeppelin-contracts" ]; then
            echo "Running: forge install foundry-rs/forge-std OpenZeppelin/openzeppelin-contracts"
            (cd code && forge install foundry-rs/forge-std OpenZeppelin/openzeppelin-contracts) || true
        else
            echo "Required libraries already present in code/lib — skipping forge install"
        fi

        # Build the project
        (cd code && forge build) || true
    fi

    # Source .env (if present) and write web env
    if [ -f .env ]; then
        # shellcheck disable=SC1091
        source .env || true
        write_web_env || true
    fi

    echo "✅ Setup complete. If you just installed Foundry, please restart your shell or run 'source ~/.zshrc' / 'source ~/.zshenv' to ensure tools are in PATH."
}

# setup() is defined earlier; the function bootstraps the project and installs Foundry.

# Main
case "$1" in
    help|-h)
        show_help
        ;;
    deploy)
        check_env
        deploy
        ;;
    test)
        test
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
    show_status)
        show_status
        ;;
    setup)
        setup
        ;;
    *)
        show_help
        ;;
esac
