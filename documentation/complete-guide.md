# 🎯 Simple Guide for Token42Art NFT

## 🚀 **Quick Setup** (10 minutes total)

### **Step 1: Setup Environment** (3 minutes)
```bash
# 1. Copy environment file
cp .env.example .env

# 2. Edit .env file and add your MetaMask private key
nano .env  # Add: PRIVATE_KEY=your_private_key_here

# 3. Install dependencies
cd code/
npm install
```

### **Step 2: Get Test ETH** (2 minutes)
1. Add Sepolia network to MetaMask (Chain ID: 11155111)
2. Get free test ETH: https://sepoliafaucet.com/

### **Step 3: Deploy Contract** (2 minutes)
```bash
npm run deploy
```
Copy the contract address from output.

### **Step 4: Mint Your NFT** (3 minutes)
1. Edit `scripts/mint.js` - replace `YOUR_CONTRACT_ADDRESS_HERE` with your deployed address
2. Run:
```bash
npm run mint
```

## 🎨 **About Your NFT**

Your NFT features:
- ✅ **22 different on-chain designs** with the number "42"
- ✅ **Fully on-chain storage** (no IPFS needed)
- ✅ **Random generation** - each mint gets a different design
- ✅ **ERC-721 standard** - works with all wallets/marketplaces
- ✅ **Sepolia testnet** - safe for learning

## 📋 **Project Requirements Status**
- ✅ Includes number "42" ✅ Artist name: thi-phng
- ✅ ERC-721 compliant ✅ Testnet deployment
- ✅ On-chain metadata ✅ Ownership verification
- ✅ Well-documented code ✅ Complete folder structure

## 🔍 **Key Information**
- **Network**: Ethereum Sepolia Testnet
- **Standard**: ERC-721
- **Supply**: 1,000 total NFTs
- **Cost**: 0.001 ETH
- **Storage**: Fully on-chain (no external dependencies)

That's it! Your 42 school NFT project is complete and meets all requirements.
