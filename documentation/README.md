# Token42Art NFT - Documentation

## What is this project?

Token42Art is a simple NFT collection that creates on-chain digital art featuring the number "42". Each NFT is completely stored on the blockchain with no external dependencies.

## How to use

1. **Setup**: Copy `.env.example` to `.env` and add your MetaMask private key
2. **Install**: `cd code/ && npm install`
3. **Deploy**: `npm run deploy`
4. **Mint**: Update contract address in `scripts/mint.js` then `npm run mint`

## What you get

- A unique NFT with random "42" artwork (22 different designs)
- Fully on-chain storage (permanent and decentralized)
- ERC-721 compliant (works with all wallets/marketplaces)
- Deployed on Sepolia testnet (safe for learning)

## Network Details

- **Blockchain**: Ethereum Sepolia Testnet
- **Cost**: 0.001 ETH (test tokens, free from faucet)
- **Supply**: 1,000 total NFTs
- **Designs**: 22 different on-chain patterns

## Technical Features

- **Standard**: ERC-721
- **Storage**: Fully on-chain (Base64 encoded SVGs)
- **Randomization**: Uses blockchain data for design selection
- **No Dependencies**: No IPFS, APIs, or external services needed

## FAQ

**Q: Do I need real money?**
A: No! This uses Sepolia testnet tokens that are free.

**Q: Do I need to upload images anywhere?**
A: No! All artwork is stored directly in the smart contract.

**Q: Can I customize the artwork?**
A: The contract has 22 pre-built designs. You can modify them in the contract code.

**Q: What if I have problems?**
A: Make sure you're on Sepolia testnet and have test ETH in your wallet.
