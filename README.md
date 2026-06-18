# 🎨 42 NFT Collection
<img width="1080" height="1080" alt="image" src="https://github.com/user-attachments/assets/463845e2-811c-463a-b192-689fea8763c8" />

Hybrid NFT storage: Beautiful SVGs on IPFS, Bonus SVGs on-chain.

## Quick Start

```bash
# Start minting interface
./manage.sh server
# Open: http://localhost:3000/native-mint.html
```

Note: If you use multiple wallet browser extensions (e.g. Rabby), temporarily disable Rabby to avoid conflicts with MetaMask when connecting the web interface.

## Contract
- **Address**: see `CONTRACT_ADDRESS` in your `.env` or run `./manage.sh status`
- **Network**: Sepolia
- **IPFS**: `bafybeifuat6mqtsgaotpz2cdw6botsxdgggaicflcrqxgentiic5kec6ze`

## Commands

```bash
./manage.sh deploy      # Deploy contract
./manage.sh test        # Run tests (for demo/validation)
./manage.sh update      # Update IPFS hash (if needed)
./manage.sh mint beautiful 0x123...  # Mint beautiful NFT
./manage.sh server      # Start web interface
./manage.sh status      # Show status
```

## Structure

```
├── code/           # Smart contract
├── web/            # Minting interface
├── SVGs/beautiful/ # 22 IPFS designs
├── documentation/  # Complete guides & references
├── manage.sh       # One script for everything
└── .env            # Your keys
```

## 📚 Documentation

- **[Complete Technical Guide](documentation/README.md)** - Architecture, tech stack, contracts
- **[Development Workflow](documentation/development-guide.md)** - Step-by-step build process  
- **[On-Chain SVG Guide](documentation/onchain-svg-guide.md)** - How to store SVGs on blockchain

**Simple. Works. Done.** ✨

## 🔧 Environment Setup

```bash
# Copy environment template
cp .env.example .env

# Add your keys to .env:
PRIVATE_KEY=your_private_key
PINATA_API_KEY=your_pinata_key
PINATA_SECRET_KEY=your_pinata_secret
```

## 📋 Contract Functions

```solidity
// Mint beautiful NFT (IPFS)
function mintBeautiful(address to) external

// Mint bonus NFT (on-chain)  
function mintBonus(address to) external

// Set IPFS hash (owner only)
function setIPFSHash(string calldata hash) external
```

## 🌐 IPFS Integration

Beautiful NFTs use IPFS storage:
- **Gateway**: `https://gateway.pinata.cloud/ipfs/{hash}`
- **Files**: `42NFT_1.svg` through `42NFT_22.svg`
- **Metadata**: JSON with image URL and traits

## 🎨 NFT Types

### Beautiful NFTs
- 22 unique high-quality SVG designs
- Stored on IPFS via Pinata
- Random selection per mint
- Rich metadata and traits

### Bonus NFTs  
- Single compact SVG design
- Fully on-chain storage
- Permanent and decentralized
- Lower gas costs

---

**Built for 42 School • Deployed on Sepolia • Ready to Use** 🚀
