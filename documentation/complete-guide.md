# 🚀 Complete Step-by-Step Guide - Token42Art NFT

## 📁 **Project Structure** 
```
├── .env.example          # Environment variables template
├── code/                 # Smart contract development with Forge
│   ├── src/             # Smart contracts
│   ├── foundry.toml     # Forge configuration
│   └── lib/             # Dependencies (auto-installed)
├── deployment/          # Contract deployment records
│   └── Deploy.s.sol     # Deployment script
├── mint/                # NFT minting records
│   └── Mint.s.sol       # Mint script
├── documentation/       # Project documentation
└── web/                # Web interface for minting
```

## 🔧 **Step 1: Environment Setup** (5 minutes)

### 1.1 Copy Environment File
```bash
cp .env.example .env
```

### 1.2 Edit .env File
```bash
nano .env  # or use your preferred editor
```

Configure all your personal variables:
```bash
PRIVATE_KEY=your_private_key_here_without_0x
SEPOLIA_RPC_URL=https://ethereum-sepolia-rpc.publicnode.com
MAINNET_RPC_URL=https://ethereum-rpc.publicnode.com
CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
ETHERSCAN_API_KEY=your_etherscan_api_key
```

### 1.3 Get Test ETH
1. Add Sepolia network to MetaMask:
   - Network Name: `Sepolia`
   - RPC URL: `https://ethereum-sepolia-rpc.publicnode.com`
   - Chain ID: `11155111`
   - Currency Symbol: `ETH`

2. Get free test ETH: https://sepoliafaucet.com/

## 🚀 **Step 2: Deploy Contract** (3 minutes)

### 2.1 Compile Contract
```bash
cd code/
forge build
```

### 2.2 Deploy to Sepolia
```bash
cd ../deployment/
forge script Deploy.s.sol --rpc-url sepolia --broadcast --root ../code
```

### 2.3 Update .env with Contract Address
The deployment script will save the contract address to `deployment/contract-address.txt`. 

Copy the contract address and update your `.env` file:
```bash
CONTRACT_ADDRESS=0xYourActualContractAddressHere
```

## 🎨 **Step 3: Mint Your NFT** (2 minutes)

```bash
cd ../mint/
forge script Mint.s.sol --rpc-url sepolia --broadcast --root ../code
```

The mint info will be saved to `mint/mint-info.txt`

## 🌐 **Step 4: Setup Website** (Optional - 5 minutes)

### 4.1 Update Web Interface
Edit `web/index.html` and replace:
```javascript
const CONTRACT_ADDRESS = "0x..."; // Replace with your deployed contract address
```

### 4.2 Serve Website Locally
```bash
cd ../web/
python3 -m http.server 8000
```

Open: http://localhost:8000

## ✅ **Verification Steps**

### Check on Etherscan
1. Go to https://sepolia.etherscan.io/
2. Search your contract address
3. Verify deployment and transactions

### Check in MetaMask
1. Open MetaMask
2. Go to "NFTs" tab  
3. Should see your Token42Art NFT

### Test Contract Functions
```bash
# Check total supply
cast call $CONTRACT_ADDRESS "totalSupply()" --rpc-url $SEPOLIA_RPC_URL

# Check your NFT ownership (replace TOKEN_ID)
cast call $CONTRACT_ADDRESS "ownerOf(uint256)" 0 --rpc-url $SEPOLIA_RPC_URL
```

## 🔍 **Troubleshooting**

### Common Issues:

**"Insufficient funds"**
- Get more test ETH from faucet
- Check you're on Sepolia network

**"Private key not found"**  
- Ensure .env file is in root directory
- Check private key format (no 0x prefix)

**"CONTRACT_ADDRESS not set"**
- Update .env file with deployed contract address
- Make sure address is not 0x0000000000000000000000000000000000000000

## 📋 **Project Requirements Status**

- ✅ ERC-721 NFT contract created
- ✅ Includes number "42" in artwork  
- ✅ Artist name: thi-phng in metadata
- ✅ Fully on-chain storage (no IPFS needed)
- ✅ Deployed on Ethereum Sepolia testnet
- ✅ Complete documentation provided
- ✅ Proper 4-folder structure with scripts in correct locations
- ✅ Uses Forge/Foundry framework
- ✅ All personal variables in .env file

## 🎯 **Key Information**

- **Network**: Ethereum Sepolia Testnet
- **Standard**: ERC-721  
- **Supply**: 1,000 total NFTs
- **Cost**: 0.001 ETH (test tokens)
- **Designs**: 22 different on-chain patterns
- **Storage**: Fully on-chain (Base64 encoded SVGs)
- **Framework**: Forge/Foundry

## 📝 **Commands Summary**

```bash
# Setup
cp .env.example .env
# Edit .env with your personal variables

# Deploy
cd code/
forge build
cd ../deployment/
forge script Deploy.s.sol --rpc-url sepolia --broadcast --root ../code

# Update .env with CONTRACT_ADDRESS from deployment output

# Mint  
cd ../mint/
forge script Mint.s.sol --rpc-url sepolia --broadcast --root ../code

# Verify
cast call $CONTRACT_ADDRESS "totalSupply()" --rpc-url $SEPOLIA_RPC_URL
```

## 🏗️ **Folder Organization**

- **code/**: All smart contract development
- **deployment/**: Deploy script + deployment records
- **mint/**: Mint script + mint records  
- **documentation/**: All project documentation
- **web/**: Web interface for users

That's it! Your 42 school NFT project is complete with proper organization. 🎉
