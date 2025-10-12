# 🎯 Complete Step-by-Step Guide for thi-phng

## 🎨 **STEP 1: Create Your Artwork** (15 minutes)

### What You Need to Do:
1. **Create an image that includes the number "42"**
   - Can be digital art, drawing, photo, anything creative
   - Must clearly show "42" somewhere
   - Size: Recommended 1000x1000 pixels or similar square
   - Format: PNG, JPG, **or SVG** (SVG is great for crisp graphics!)

### Why This Matters:
- Required by 42 school project
- Will be stored permanently on IPFS
- Represents your unique NFT

### Ideas for Your "42" Art:
- **SVG vector art** with "42" (scales perfectly!)
- Draw "42" in artistic font
- Photo of "42" written somewhere
- Digital design incorporating "42"
- Pixel art with "42"

### **SVG Advantages:**
- ✅ **Vector format**: Scales to any size perfectly
- ✅ **Small file size**: Efficient for blockchain storage
- ✅ **Code-based**: Can create programmatically
- ✅ **Sharp**: Always crisp at any resolution

---

## 🌐 **STEP 2: Upload to IPFS** (10 minutes)

### What is IPFS?
- **I**nter**P**lanetary **F**ile **S**ystem
- Decentralized storage (not on one server)
- Files get unique hash (like fingerprint)
- Perfect for NFT storage

### How to Upload (Using Pinata - Easiest):
1. **Go to** https://pinata.cloud/
2. **Sign up** for free account
3. **Upload your image**:
   - Click "Upload" → "File"
   - Select your "42" artwork
   - Click "Upload"
4. **Copy the IPFS hash**:
   - Will look like: `QmXXXXXXXXXXXXXXXXXXXX`
   - Save this hash!

### Why Pinata?
- Free tier available
- Easy to use
- Reliable IPFS pinning
- Used by many NFT projects

---

## 🔧 **STEP 3: Set Up Development Environment** (20 minutes)

### Install Dependencies:
```bash
cd /home/thi-phng/42/TOKEN42_PROJECTS/ft_tokenizerArt/code/
npm install
```

### What This Installs:
- **Hardhat**: Ethereum development framework
- **OpenZeppelin**: Secure smart contract library
- **Ethers.js**: Library to interact with Ethereum

### Set Up Environment Variables:
```bash
cp .env.example .env
nano .env  # or use your preferred editor
```

### Fill in .env file:
```bash
# Get your MetaMask private key:
# MetaMask → Account Details → Export Private Key
PRIVATE_KEY=your_private_key_without_0x

# Get free Infura API key:
# Go to infura.io → Sign up → Create project → Copy Project ID
INFURA_API_KEY=your_infura_project_id

# Optional: Etherscan API for verification
ETHERSCAN_API_KEY=your_etherscan_api_key
```

---

## 💰 **STEP 4: Get Test ETH** (5 minutes)

### Why You Need Test ETH:
- Deploy contract costs gas (transaction fees)
- Mint NFT costs gas
- Test ETH is free and safe

### How to Get Test ETH:
1. **Add Sepolia Network to MetaMask**:
   - Network Name: Sepolia
   - RPC URL: https://sepolia.infura.io/v3/YOUR_INFURA_KEY
   - Chain ID: 11155111
   - Currency Symbol: ETH

2. **Get Free Test ETH**:
   - Go to https://sepoliafaucet.com/
   - Enter your wallet address
   - Wait for ETH to arrive

---

## 🚀 **STEP 5: Deploy Your Contract** (5 minutes)

### Compile the Contract:
```bash
npm run compile
```
**What happens**: Converts Solidity code to bytecode

### Deploy to Sepolia:
```bash
npm run deploy:sepolia
```

### What You'll See:
```
🚀 Starting deployment of Token42NFT...
Deploying contracts with the account: 0xYourAddress
Account balance: 0.5 ETH
Deploying Token42NFT contract...
✅ Token42NFT deployed to: 0xContractAddress
Contract name: Token42Art
Contract symbol: T42A
Max supply: 42
```

### Save This Information:
- **Contract Address**: You'll need this to interact with your NFT
- **Transaction Hash**: Proof of deployment

---

## 🎨 **STEP 6: Create and Upload Metadata** (10 minutes)

### What is Metadata?
- JSON file describing your NFT
- Contains name, description, image link, properties
- Also stored on IPFS

### Create metadata.json:
```json
{
  "name": "42 Token Art by thi-phng",
  "description": "A unique NFT created for the 42 school TokenizerArt project featuring the number 42",
  "image": "ipfs://YOUR_IMAGE_IPFS_HASH",
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
      "trait_type": "Number",
      "value": "42"
    }
  ]
}
```

### Upload metadata.json to IPFS:
1. Save the JSON file
2. Upload to Pinata (same process as image)
3. Get metadata IPFS hash

---

## 🎯 **STEP 7: Mint Your NFT** (5 minutes)

### Update mint script:
```bash
nano scripts/mint.js
```

### Replace the metadata URI:
```javascript
const metadataURI = "ipfs://YOUR_METADATA_IPFS_HASH";
```

### Mint Your NFT:
```bash
npx hardhat run scripts/mint.js --network sepolia
```

### What You'll See:
```
🎨 Starting NFT minting process...
Loading contract from: 0xYourContractAddress
Minting NFT to: 0xYourAddress
✅ NFT minted successfully!
Token ID: 1
NFT Owner: 0xYourAddress
```

---

## ✅ **STEP 8: Verify Everything Works**

### Check on Etherscan:
1. Go to https://sepolia.etherscan.io/
2. Search your contract address
3. See your contract and transactions

### Check in MetaMask:
1. Open MetaMask
2. Go to "NFTs" tab
3. Should see your Token42Art NFT

### Test Ownership Function:
```bash
npx hardhat console --network sepolia
```
```javascript
const contract = await ethers.getContractAt("Token42NFT", "YOUR_CONTRACT_ADDRESS")
await contract.ownerOf(1)  // Should return your address
```

---

## 🎉 **What You've Accomplished**

1. ✅ Created unique artwork with "42"
2. ✅ Stored artwork on decentralized IPFS
3. ✅ Deployed ERC-721 smart contract to Ethereum
4. ✅ Minted your first NFT
5. ✅ Verified ownership on blockchain
6. ✅ Met all 42 school requirements

### Key Information for Your Evaluation:
- **Contract Address**: 0xYourContractAddress
- **Network**: Ethereum Sepolia Testnet
- **Token ID**: 1
- **Artist**: thi-phng
- **Standard**: ERC-721
- **IPFS Image**: ipfs://YourImageHash
- **IPFS Metadata**: ipfs://YourMetadataHash

## 🔍 **Understanding the "Why" Behind Each Step**

### Why ERC-721?
- Industry standard for unique tokens
- Compatible with all major platforms
- Battle-tested security

### Why IPFS?
- Decentralized (no single point of failure)
- Immutable (content can't be changed)
- Permanent storage

### Why Ethereum?
- Most established blockchain for NFTs
- Largest ecosystem
- Best tooling and support

### Why Testnet?
- No real money at risk
- Same functionality as mainnet
- Perfect for learning

This is a production-ready NFT that meets all requirements while being simple and secure!
