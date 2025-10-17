# 🎯 Project Development Guide

## Phase 1: Planning & Setup (30min)

### 1.1 Project Requirements
- [x] Hybrid storage: IPFS + On-chain
- [x] 22 beautiful SVGs (IPFS)
- [x] 1 bonus SVG (on-chain)
- [x] Simple web interface
- [x] Sepolia testnet deployment

### 1.2 Environment Preparation
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Setup project structure
mkdir ft_tokenizerArt && cd ft_tokenizerArt
git init

# Create directories
mkdir code web SVGs deployment mint documentation
mkdir SVGs/beautiful
```

### 1.3 Dependencies Setup
```bash
cd code
forge install OpenZeppelin/openzeppelin-contracts
forge install foundry-rs/forge-std
```

---

## Phase 2: Smart Contract Development (2-3 hours)

### 2.1 Core Contract (`Token42NFT.sol`)
```solidity
// Key features to implement:
1. ERC721 inheritance
2. Dual storage mapping: isBeautifulNFT[tokenId] => bool
3. IPFS hash storage: string public ipfsHash
4. On-chain SVG constant: string private constant BONUS_SVG
5. Dynamic tokenURI() function
6. Mint functions: mintBeautiful() & mintBonus()
7. Owner controls: setIPFSHash()
```

### 2.2 Testing Strategy
```bash
# Create comprehensive tests
forge test --match-contract Token42NFTTest -vv

# Test coverage:
- Basic minting functionality
- Access control (only owner can set IPFS)
- Token URI generation for both types
- Mixed minting scenarios
```

### 2.3 Deployment Scripts
```solidity
// deployment/Deploy.s.sol
contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        Token42NFT nft = new Token42NFT();
        console.log("Deployed to:", address(nft));
        vm.stopBroadcast();
    }
}
```

---

## Phase 3: IPFS Integration (1-2 hours)

### 3.1 SVG Preparation
```bash
# Organize SVG files
SVGs/
├── beautiful/
│   ├── 42NFT_1.svg    # High quality designs
│   ├── 42NFT_2.svg
│   └── ... (up to 22)
└── bonusNFT.svg       # Simple design for on-chain
```

### 3.2 Pinata Upload Process
1. **Manual Upload** (Recommended for small projects)
   - Go to [Pinata Dashboard](https://app.pinata.cloud/)
   - Upload entire `SVGs` folder
   - Get IPFS hash (CID)

2. **API Upload** (For automation)
   ```bash
   # Use Pinata API with curl
   curl -X POST "https://api.pinata.cloud/pinning/pinFileToIPFS" \
        -H "pinata_api_key: YOUR_KEY" \
        -F "file=@SVGs.tar.gz"
   ```

### 3.3 Contract Configuration
```bash
# Update IPFS hash on deployed contract
cast send $CONTRACT_ADDRESS "setIPFSHash(string)" "$IPFS_HASH" \
     --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
```

---

## Phase 4: Web Interface (2-3 hours)

### 4.1 Native Web3 Implementation
```html
<!-- Key components -->
1. MetaMask connection detection
2. Network validation (Sepolia)
3. Contract interaction (mint functions)
4. Transaction status tracking
5. Error handling & user feedback
```

### 4.2 Core JavaScript Functions
```javascript
// Essential functions to implement:
- connectWallet() - MetaMask connection
- checkNetwork() - Ensure Sepolia
- mintNFT(type) - Call contract functions
- waitForTransaction(hash) - Status monitoring
- updateUI() - Dynamic interface updates
```

### 4.3 User Experience
- Clean, minimal design
- Two clear buttons: "Mint Beautiful" & "Mint Bonus"
- Real-time transaction feedback
- Error messages with solutions
- Responsive layout

---

## Phase 5: Integration & Testing (1-2 hours)

### 5.1 End-to-End Testing
```bash
# Test complete workflow
1. Deploy contract: ./manage.sh deploy
2. Run tests: ./manage.sh test
3. Update IPFS: ./manage.sh update
4. Start web server: ./manage.sh server
5. Test minting both types via web interface
6. Verify NFTs on Etherscan
```

### 5.2 Verification Checklist
- [ ] Contract deployed on Sepolia
- [ ] IPFS hash configured correctly
- [ ] Beautiful NFTs load IPFS images
- [ ] Bonus NFTs show on-chain SVG
- [ ] Web interface connects to MetaMask
- [ ] Both mint functions work
- [ ] Transaction status updates properly
- [ ] NFTs appear in wallet

---

## Phase 6: Documentation & Cleanup (1 hour)

### 6.1 Project Organization
```bash
# Final structure
├── code/           # Smart contract & tests
├── deployment/     # Deploy scripts
├── mint/          # Mint scripts
├── web/           # Frontend
├── SVGs/          # Asset files
├── documentation/ # This folder
├── manage.sh      # Main script
└── README.md      # Quick reference
```

### 6.2 Documentation Requirements
- [ ] Complete README with quick start
- [ ] Technical documentation (this file)
- [ ] Contract function explanations
- [ ] Technology stack references
- [ ] Development workflow guide

---

## 🛠️ Troubleshooting Common Issues

### Contract Deployment
```bash
# Gas estimation errors
forge script Deploy.s.sol --gas-estimate

# RPC connection issues  
curl -X POST -H "Content-Type: application/json" \
     --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
     $SEPOLIA_RPC_URL
```

### IPFS Integration
```bash
# Test IPFS gateway access
curl -I "https://gateway.pinata.cloud/ipfs/$IPFS_HASH/beautiful/42NFT_1.svg"

# Verify file structure
ipfs ls $IPFS_HASH  # If you have IPFS CLI installed
```

### Web3 Frontend
```javascript
// Debug MetaMask connection
if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask detected');
} else {
    console.log('Please install MetaMask');
}

// Check contract interaction
const contract = new window.ethereum.request({
    method: 'eth_call',
    params: [{ to: CONTRACT_ADDRESS, data: '0x...' }]
});
```

---

## 📊 Project Metrics

### Development Time Estimate
- **Total**: 8-10 hours
- **Smart Contract**: 3-4 hours
- **IPFS Setup**: 1-2 hours  
- **Web Interface**: 2-3 hours
- **Testing & Documentation**: 2-3 hours

### Gas Costs (Sepolia)
- **Contract Deployment**: ~2-3M gas
- **Set IPFS Hash**: ~50K gas
- **Mint Beautiful NFT**: ~80K gas
- **Mint Bonus NFT**: ~100K gas (slightly higher due to on-chain data)

### File Sizes
- **Beautiful SVGs**: ~2-10KB each
- **Bonus SVG**: ~500 bytes (optimized)
- **Contract Size**: ~15KB compiled
- **Web Interface**: ~8KB (no dependencies)

---

**Next Steps**: Follow Phase 1-6 sequentially for a complete implementation! 🚀
