# 🎨 Token42Art NFT

A minimal NFT project for 42 school featuring on-chain generative art with the number "42".

## ✨ Features

- **Fully On-Chain**: All artwork stored directly on blockchain (no IPFS needed)
- **22 Unique Designs**: Random generation from pre-built SVG patterns
- **Simple Setup**: Deploy and mint in under 10 minutes
- **No External Dependencies**: Everything stored on-chain

## 🚀 Quick Start

```bash
# 1. Setup environment
cp .env.example .env
# Edit .env and add your private key

# 2. Install & deploy
cd code/
npm install
npm run deploy

# 3. Mint NFT
# Update contract address in scripts/mint.js
npm run mint
```

## 📁 Project Structure

```
├── .env.example          # Environment variables template
├── contract-address.txt  # Deployed contract info (auto-generated)
├── code/                 # Smart contract code
│   ├── Token42NFT.sol   # Main NFT contract
│   ├── scripts/
│   │   ├── deploy.js    # Deployment script
│   │   └── mint.js      # Minting script
│   └── package.json     # Dependencies
├── documentation/        # Project docs
├── SVGs/                # 22 SVG artworks (optional reference)
└── web/                 # Simple web interface
```

## 🔍 Technical Details

- **Standard**: ERC-721
- **Network**: Ethereum Sepolia Testnet
- **Supply**: 1,000 total NFTs
- **Price**: 0.001 ETH
- **Storage**: Fully on-chain (Base64 encoded SVGs)

## 📋 Requirements Status

- ✅ ERC-721 NFT contract
- ✅ Includes number "42"
- ✅ Artist name: thi-phng
- ✅ Testnet deployment
- ✅ Complete documentation
- ✅ On-chain storage

See `documentation/complete-guide.md` for detailed instructions.