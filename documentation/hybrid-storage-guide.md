# Hybrid Storage Implementation Guide

## Overview

This NFT contract implements two storage methods:

1. **Onchain Storage**: For the small bonus SVG (`bonusNFT.svg` - 1.7KB)
2. **Cloud Storage (IPFS)**: For the 22 large SVGs (100KB - 6MB each)

## Storage Architecture

### Onchain Storage
- **File**: `bonusNFT.svg`
- **Size**: 1,730 bytes
- **Storage Method**: Embedded directly in the smart contract as a string
- **Access**: Immediate, no external dependencies
- **Cost**: Higher gas cost for deployment, but permanent and decentralized

### Cloud Storage (IPFS)
- **Files**: `42NFT_1.svg` through `42NFT_22.svg`
- **Size**: 100KB - 6MB each
- **Storage Method**: IPFS with Pinata pinning service
- **Access**: Via IPFS gateway URLs
- **Cost**: Lower gas cost, small monthly pinning fee

## Implementation Steps

### Step 1: Upload Large SVGs to IPFS

```bash
# Install IPFS CLI (if not already installed)
# Visit: https://docs.ipfs.io/install/command-line/

# Create a folder for the large SVGs
mkdir ipfs-svgs
cp SVGs/42NFT_*.svg ipfs-svgs/

# Add the folder to IPFS
ipfs add -r ipfs-svgs

# Note the hash of the folder - you'll need this for the contract
```

### Step 2: Pin to Pinata (Recommended)

1. Sign up at [Pinata](https://www.pinata.cloud/)
2. Get your API keys
3. Upload the folder using Pinata's interface or API
4. Get the IPFS hash

### Step 3: Deploy the Contract

```solidity
// The contract is already configured with:
// - bonusSVG stored onchain
// - baseTokenURI set to Pinata gateway
// - setIPFSHash() function to set the folder hash
```

### Step 4: Set IPFS Hash

After deployment, call the `setIPFSHash()` function with your folder hash:

```solidity
// Replace with your actual IPFS hash
contract.setIPFSHash("QmYourIPFSHashHere");
```

## Token URI Generation Logic

### For Onchain Tokens (Design ID 22)
```
data:image/svg+xml;base64,[base64_encoded_svg]
```

### For Cloud Tokens (Design ID 0-21)
```
https://gateway.pinata.cloud/ipfs/[IPFS_HASH]/42NFT_[DESIGN_ID+1].svg
```

## Benefits of Hybrid Approach

1. **Cost Efficiency**: Large files stored cheaply on IPFS
2. **Reliability**: Small bonus SVG is permanently onchain
3. **Flexibility**: Can update IPFS gateway if needed
4. **Scalability**: Can add more designs without contract changes

## Monitoring and Maintenance

- Monitor IPFS pinning status on Pinata
- Ensure gateway accessibility
- Keep backup copies of all SVG files
- Consider multiple pinning services for redundancy

## Gas Considerations

- **Onchain storage**: ~20-30 gas per byte for permanent storage
- **IPFS hash storage**: Fixed cost regardless of file size
- **Deployment**: Higher initial cost due to onchain SVG, but manageable for 1.7KB
