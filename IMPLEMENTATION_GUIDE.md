# Complete Implementation Guide: Hybrid NFT Storage

## Summary

I've implemented a hybrid storage solution for your 42 NFT Art Collection:

### ✅ What's Implemented

1. **Smart Contract (`Token42NFT.sol`)**
   - **Onchain Storage**: `bonusNFT.svg` (1.7KB) stored directly in the contract
   - **Cloud Storage**: 22 large SVGs (100KB-6MB) stored on IPFS
   - **Hybrid tokenURI()**: Automatically serves the correct image based on token type

2. **Upload Scripts**
   - `scripts/upload-to-ipfs.sh`: IPFS CLI upload script
   - `scripts/pinata_upload.py`: Python script for Pinata API upload

3. **Documentation**
   - Complete setup and usage guide
   - Test contract for validation

## 🎯 How It Works

### Token Generation
```solidity
// Each minted token gets a random design ID (0-22)
// Design ID 22 = onchain bonus SVG
// Design ID 0-21 = cloud-stored large SVGs
```

### Storage Logic
- **Design 22 (Bonus)**: SVG data embedded in contract → `data:image/svg+xml;base64,...`
- **Design 0-21 (Large)**: IPFS URLs → `https://gateway.pinata.cloud/ipfs/{hash}/42NFT_{id+1}.svg`

### Token Metadata Example
```json
{
  "name": "42 Art #0 by thi-phng",
  "description": "42 art collection with hybrid storage",
  "image": "https://gateway.pinata.cloud/ipfs/QmHash.../42NFT_1.svg",
  "attributes": [
    {"trait_type": "Design ID", "value": "0"},
    {"trait_type": "Storage Type", "value": "Cloud (IPFS)"},
    {"trait_type": "Artist", "value": "thi-phng"},
    {"trait_type": "School", "value": "42"}
  ]
}
```

## 🚀 Deployment Steps

### 1. Upload Large SVGs to IPFS
```bash
# Option A: Using IPFS CLI
./scripts/upload-to-ipfs.sh

# Option B: Using Pinata API
python3 scripts/pinata_upload.py
```

### 2. Deploy Smart Contract
```bash
# Using Foundry (when available)
forge create --rpc-url YOUR_RPC_URL \
  --private-key YOUR_PRIVATE_KEY \
  src/Token42NFT.sol:Token42NFT

# Or use Remix IDE with the contract code
```

### 3. Set IPFS Hash
```solidity
// After deployment, set the IPFS folder hash
contract.setIPFSHash("QmYourIPFSHashHere");
```

### 4. Test Minting
```solidity
// Mint tokens (0.001 ETH each)
contract.mint{value: 0.001 ether}();

// Check token metadata
string memory uri = contract.tokenURI(0);
```

## 💰 Cost Analysis

### Gas Costs
- **Deployment**: ~3-4M gas (due to onchain SVG)
- **Mint**: ~80-100k gas per token
- **Set IPFS Hash**: ~30k gas (one-time)

### Storage Costs
- **Onchain**: Permanent, no recurring costs
- **IPFS**: ~$1-3/month for pinning 22 files on Pinata

## 🔧 Contract Interface

### Public Functions
```solidity
function mint() external payable                    // Mint new token (0.001 ETH)
function tokenURI(uint256) returns (string)         // Get metadata URI
function setIPFSHash(string) external onlyOwner     // Set IPFS folder hash
function setBaseTokenURI(string) external onlyOwner // Update gateway URL
function getTokenDesign(uint256) returns (uint256)  // Get design ID
function getTokenStorageType(uint256) returns (StorageType) // Get storage type
function getBonusSVG() returns (string)             // View onchain SVG
```

## 🎨 Benefits of This Approach

1. **Cost Efficient**: Large files on IPFS, only small bonus onchain
2. **Decentralized**: IPFS ensures long-term availability
3. **Flexible**: Can update IPFS gateway if needed
4. **Transparent**: Storage type visible in metadata
5. **Reliable**: Bonus SVG is permanently onchain

## ⚡ Quick Start

1. **Upload SVGs**:
   ```bash
   cd /home/thi-phng/42/TOKEN42_PROJECTS/ft_tokenizerArt
   ./scripts/upload-to-ipfs.sh
   ```

2. **Deploy Contract**: Use the `Token42NFT.sol` code in Remix or Foundry

3. **Configure**: Call `setIPFSHash()` with your IPFS hash

4. **Mint & Test**: Mint tokens and verify metadata URLs work

## 📱 Example Token URLs

After setup, your tokens will have:
- **Token 0** (Design 0): `https://gateway.pinata.cloud/ipfs/{hash}/42NFT_1.svg`
- **Token 1** (Design 1): `https://gateway.pinata.cloud/ipfs/{hash}/42NFT_2.svg`
- **Token X** (Design 22): Onchain SVG data embedded in metadata

## 🎯 Next Steps

1. Choose IPFS upload method (CLI or Pinata API)
2. Upload your SVGs and note the IPFS hash
3. Deploy the contract on your preferred network
4. Set the IPFS hash on the deployed contract
5. Test mint a few tokens to verify everything works

The implementation is complete and ready for deployment!
