# Token42NFT - Hybrid Storage NFT Collection

A minimal ERC721 NFT contract with dual storage: beautiful SVGs on IPFS and bonus SVGs onchain.

## Features

- **Hybrid Storage**: Beautiful SVGs on IPFS, bonus SVGs onchain
- **Simple Interface**: Two-button web interface for minting
- **No Payment Required**: Free minting for both types
- **Artist Attribution**: Built-in artist tracking

## Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo>
cd ft_tokenizerArt
```

### 2. Environment Configuration

Create a `.env` file:

```bash
RPC=https://your_rpc_url
PRIVATE_KEY=0xYOUR_PRIVATE_KEY
CONTRACT_ADDRESS=0xYOUR_DEPLOYED_CONTRACT
RECIPIENT_ADDRESS=0xRECIPIENT_ADDRESS
MINT_TYPE=beautiful  # or "bonus"
```

### 3. Upload SVGs to IPFS

```bash
# Upload your 22 beautiful SVGs to IPFS
./scripts/upload-to-ipfs.sh
```

## Deployment

Deploy to your network:

```bash
cd deployment
forge script Deploy.s.sol --rpc-url $RPC --private-key $PRIVATE_KEY --broadcast
```

Set IPFS hash after deployment:

```bash
# Update contract with IPFS hash
cast send $CONTRACT_ADDRESS "setIPFSHash(string)" "QmYourIPFSHash" --rpc-url $RPC --private-key $PRIVATE_KEY
```

## Minting NFTs

### Web Interface

Open `web/simple.html` in browser:
- 🎨 **Mint Beautiful SVG**: High-quality art from IPFS
- ⛓️ **Mint Bonus SVG**: Simple onchain SVG

### Command Line

```bash
cd mint
# Mint beautiful NFT
MINT_TYPE=beautiful forge script MintSimple.s.sol --rpc-url $RPC --private-key $PRIVATE_KEY --broadcast

# Mint bonus NFT  
MINT_TYPE=bonus forge script MintSimple.s.sol --rpc-url $RPC --private-key $PRIVATE_KEY --broadcast
```

## Contract Functions

```solidity
// Mint beautiful SVG (stored on IPFS)
function mintBeautiful(address to) external

// Mint bonus SVG (stored onchain)
function mintBonus(address to) external

// Check if token is beautiful type
function isBeautifulNFT(uint256 tokenId) external view returns (bool)

// Set IPFS hash (owner only)
function setIPFSHash(string memory _ipfsHash) external onlyOwner
```

## Project Structure

```
├── code/src/
│   └── Token42NFT.sol      # Main contract
├── deployment/
│   └── Deploy.s.sol        # Deployment script
├── mint/
│   └── MintSimple.s.sol    # Minting script
├── web/
│   └── simple.html         # Simple web interface
├── scripts/
│   └── upload-to-ipfs.sh   # IPFS upload helper
└── SVGs/                   # Your artwork files
    ├── 42NFT_1.svg ... 42NFT_22.svg  # Beautiful SVGs (for IPFS)
    └── bonusNFT.svg        # Bonus SVG (onchain)
```

## Storage Types

### Beautiful NFTs (IPFS)
- **Files**: `42NFT_1.svg` through `42NFT_22.svg`
- **Storage**: IPFS with Pinata pinning
- **URL Format**: `https://gateway.pinata.cloud/ipfs/{hash}/42NFT_{id}.svg`

### Bonus NFTs (Onchain)
- **File**: Simple 42 SVG embedded in contract
- **Storage**: Direct blockchain storage
- **Format**: `data:image/svg+xml;base64,{base64_svg}`

## Metadata Example

```json
{
  "name": "42 Art #0 by thi-phng",
  "description": "Simple 42 art collection",
  "image": "https://gateway.pinata.cloud/ipfs/.../42NFT_1.svg",
  "attributes": [
    {"trait_type": "Type", "value": "Beautiful (IPFS)"},
    {"trait_type": "Artist", "value": "thi-phng"}
  ]
}
```

## Setup Steps

1. **Upload SVGs**: Use `./scripts/upload-to-ipfs.sh`
2. **Deploy Contract**: Run deployment script
3. **Set IPFS Hash**: Call `setIPFSHash()` with your IPFS folder hash
4. **Update Web Interface**: Replace `CONTRACT_ADDRESS` in `web/simple.html`
5. **Test Minting**: Use web interface or command line

## Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [IPFS Documentation](https://docs.ipfs.io/)
- [Pinata Pinning Service](https://www.pinata.cloud/)
