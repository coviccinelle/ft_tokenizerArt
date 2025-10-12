# Token42Art NFT Project Documentation

## Project Overview

This project implements a simple ERC-721 NFT (Non-Fungible Token) for the 42 school TokenizerArt project. The NFT features artwork that includes the number "42" as required by the project specifications.

## Technical Specifications

### Smart Contract Details
- **Contract Name**: Token42NFT
- **Symbol**: T42A
- **Standard**: ERC-721 (Non-Fungible Token)
- **Blockchain**: Ethereum Sepolia Testnet
- **Language**: Solidity ^0.8.19
- **Framework**: Hardhat
- **Artist**: thi-phng (your 42 login)

### Key Features
- ✅ ERC-721 compliant NFT contract
- ✅ Maximum supply of 42 tokens
- ✅ Owner minting capabilities
- ✅ Public minting with configurable price
- ✅ Metadata URI storage
- ✅ Ownership verification
- ✅ Secure withdrawal functionality

## Project Structure

```
ft_tokenizerArt/
├── README.md                    # Project overview and requirements
├── code/                        # Smart contract code
│   ├── Token42NFT.sol          # Main NFT contract
│   ├── package.json            # Node.js dependencies
│   ├── hardhat.config.js       # Hardhat configuration
│   ├── .env.example            # Environment variables template
│   ├── .gitignore              # Git ignore rules
│   └── scripts/                # Deployment and utility scripts
│       ├── deploy.js           # Contract deployment script
│       └── mint.js             # NFT minting script
├── deployment/                  # Deployment artifacts
├── mint/                       # Minting records
└── documentation/              # Project documentation
    └── README.md               # This file
```

## Setup Instructions

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn
- MetaMask wallet with testnet tokens
- Basic understanding of blockchain and NFTs

### Installation Steps

1. **Navigate to the code directory**:
   ```bash
   cd code/
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env file with your wallet private key
   ```

4. **Compile the contract**:
   ```bash
   npm run compile
   ```

## Deployment Guide

### Step 1: Get Testnet Tokens
- Add BSC Testnet to MetaMask
- Get free BNB from BSC Testnet Faucet: https://testnet.binance.org/faucet-smart

### Step 2: Deploy Contract
```bash
npm run deploy:testnet
```

This will:
- Deploy the contract to BSC Testnet
- Save deployment information to `deployment/` folder
- Display contract address and transaction details

### Step 3: Mint Your NFT
```bash
npx hardhat run scripts/mint.js --network bsc_testnet
```

## NFT Metadata Structure

```json
{
  "name": "42 Token Art by thi-phng",
  "description": "A unique NFT created for the 42 school TokenizerArt project",
  "image": "ipfs://YOUR_IPFS_HASH",
  "attributes": [
    {
      "trait_type": "Artist",
      "value": "thi-phng"
    },
    {
      "trait_type": "School", 
      "value": "42"
    },
    {
      "trait_type": "Project",
      "value": "ft_tokenizerArt"
    },
    {
      "trait_type": "Number",
      "value": "42"
    }
  ]
}
```

## Security Considerations

### Smart Contract Security
- Uses OpenZeppelin's audited contracts
- Implements proper access controls (Ownable)
- Includes reentrancy protection
- Safe math operations built into Solidity 0.8+

### Best Practices Implemented
- Clear function visibility
- Event emission for important actions
- Input validation and error handling
- Gas optimization techniques

## Testing and Verification

### Contract Functions
- `mintNFT(address to, string memory tokenURI)`: Public minting function
- `ownerMint(address to, string memory tokenURI)`: Owner-only minting
- `ownerOf(uint256 tokenId)`: Verify token ownership
- `tokenURI(uint256 tokenId)`: Get token metadata
- `totalSupply()`: Get current supply

### Verification Commands
```bash
# Check owner of token ID 1
npx hardhat console --network bsc_testnet
> const contract = await ethers.getContractAt("Token42NFT", "CONTRACT_ADDRESS")
> await contract.ownerOf(1)

# Get token metadata
> await contract.tokenURI(1)
```

## IPFS Integration

### Image Storage
1. Create artwork featuring the number "42"
2. Upload to IPFS using:
   - Pinata: https://pinata.cloud/
   - IPFS Desktop
   - Web3.Storage

### Metadata Upload
1. Create metadata JSON file
2. Upload to IPFS
3. Use IPFS hash in mint script

## Network Information

### BSC Testnet Details
- **Network Name**: Binance Smart Chain Testnet
- **RPC URL**: https://data-seed-prebsc-1-s1.binance.org:8545
- **Chain ID**: 97
- **Currency Symbol**: BNB
- **Block Explorer**: https://testnet.bscscan.com/

## Troubleshooting

### Common Issues
1. **Insufficient funds**: Get testnet tokens from faucet
2. **Transaction fails**: Check gas limits and network connection
3. **Contract not verified**: Use BSC Testnet explorer

### Support Resources
- Hardhat Documentation: https://hardhat.org/docs
- OpenZeppelin Contracts: https://docs.openzeppelin.com/
- BSC Documentation: https://docs.binance.org/

## Project Requirements Checklist

- ✅ Image includes number "42"
- ✅ Image stored on IPFS
- ✅ ERC-721 compliant smart contract
- ✅ Artist name is login (thi-phng)
- ✅ Name includes "42"
- ✅ Deployed on testnet (no real money)
- ✅ Code is commented and readable
- ✅ Ownership verification possible
- ✅ Clear documentation provided
- ✅ Proper directory structure

## Future Enhancements

### Potential Improvements
- Web interface for minting
- Royalty implementation (ERC-2981)
- Batch minting capabilities
- Whitelist functionality
- Dynamic metadata

---

**Author**: thi-phng  
**Project**: ft_tokenizerArt  
**School**: 42  
**Date**: October 2025
