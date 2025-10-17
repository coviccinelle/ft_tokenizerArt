# 📚 42 NFT Collection - Complete Documentation

## 🏗️ Project Architecture

### Overview
This project implements a **hybrid NFT storage system** combining:
- **IPFS storage** for high-quality beautiful SVGs (22 designs)
- **On-chain storage** for compact bonus SVGs (1 design)
- **Web3 minting interface** using native browser APIs

### Key Components
1. **Smart Contract** (`Token42NFT.sol`) - ERC721 with dual storage
2. **Web Interface** (`native-mint.html`) - MetaMask integration
3. **IPFS Integration** - Pinata cloud storage
4. **Management Scripts** - Single `manage.sh` for all operations

---

## 🔧 Technology Stack

### Smart Contract Development
- **[Solidity ^0.8.19](https://docs.soliditylang.org/)** - Smart contract language
- **[OpenZeppelin](https://docs.openzeppelin.com/)** - Secure contract templates
  - `ERC721` - NFT standard implementation
  - `Ownable` - Access control
  - `Base64` & `Strings` - Metadata encoding

### Development & Testing
- **[Foundry](https://book.getfoundry.sh/)** - Ethereum development toolkit
  - `forge` - Build, test, deploy contracts
  - `cast` - Command-line blockchain interaction
- **[Forge-std](https://github.com/foundry-rs/forge-std)** - Testing utilities

### IPFS & Storage
- **[IPFS](https://docs.ipfs.tech/)** - Decentralized file storage
- **[Pinata](https://docs.pinata.cloud/)** - IPFS pinning service
  - Gateway: `https://gateway.pinata.cloud/ipfs/{hash}`

### Frontend & Web3
- **Native Web3 API** - Browser-based blockchain interaction
- **[MetaMask](https://docs.metamask.io/)** - Wallet connection
- **Pure HTML/CSS/JS** - No framework dependencies

### Blockchain Network
- **[Sepolia Testnet](https://sepolia.dev/)** - Ethereum test network
- **[Etherscan Sepolia](https://sepolia.etherscan.io/)** - Block explorer

---

## 🚀 Building from Scratch

### Step 1: Environment Setup
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Clone/setup project
git clone <your-repo>
cd ft_tokenizerArt

# Copy environment file
cp .env.example .env
# Fill in your keys: PRIVATE_KEY, SEPOLIA_RPC_URL, etc.
```

### Step 2: Smart Contract Development
```bash
# Initialize Foundry project
cd code
forge init --no-git

# Install dependencies
forge install OpenZeppelin/openzeppelin-contracts

# Create contract
# Edit src/Token42NFT.sol (see contract explanation below)

# Test contract
forge test
```

### Step 3: IPFS Preparation
```bash
# Prepare SVG files in SVGs/beautiful/ folder
# 22 files: 42NFT_1.svg through 42NFT_22.svg

# Upload to Pinata manually or via API
# Get IPFS hash (CID)
```

### Step 4: Contract Deployment
```bash
# Deploy to Sepolia
./manage.sh deploy

# Update IPFS hash on contract
./manage.sh update

# Test minting
./manage.sh mint beautiful 0xYourAddress
```

### Step 5: Web Interface
```bash
# Create web interface
# Edit web/native-mint.html

# Start local server
./manage.sh server

# Open http://localhost:3000/native-mint.html
```

---

## 📄 Contract Explanation

### Core Functions

#### Storage Variables
```solidity
string public ipfsHash = "";                    // IPFS hash for beautiful SVGs
mapping(uint256 => bool) public isBeautifulNFT; // Track NFT type
string private constant BONUS_SVG = '<svg...>'; // On-chain SVG
```

#### Minting Functions
```solidity
function mintBeautiful(address to) external {
    uint256 tokenId = _tokenIdCounter++;
    isBeautifulNFT[tokenId] = true;  // Mark as IPFS type
    _safeMint(to, tokenId);
}

function mintBonus(address to) external {
    uint256 tokenId = _tokenIdCounter++;
    isBeautifulNFT[tokenId] = false; // Mark as on-chain type
    _safeMint(to, tokenId);
}
```

#### Metadata Generation
```solidity
function tokenURI(uint256 tokenId) public view override returns (string memory) {
    if (isBeautifulNFT[tokenId]) {
        // IPFS URL: https://gateway.pinata.cloud/ipfs/{hash}/beautiful/42NFT_{id}.svg
        imageURI = string(abi.encodePacked(
            "https://gateway.pinata.cloud/ipfs/", ipfsHash,
            "/beautiful/42NFT_", (tokenId % 22 + 1).toString(), ".svg"
        ));
    } else {
        // Base64 encoded on-chain SVG
        imageURI = string(abi.encodePacked(
            "data:image/svg+xml;base64,", Base64.encode(bytes(BONUS_SVG))
        ));
    }
    
    // Return JSON metadata
    return Base64.encode(bytes(string(abi.encodePacked(
        '{"name": "42 Art #', tokenId.toString(), 
        '", "image": "', imageURI, '", ...}'
    ))));
}
```

---

## 🎨 On-Chain SVG Storage

### Why Store SVGs On-Chain?
- **Permanence** - Cannot be deleted or modified
- **Decentralization** - No external dependencies
- **Lower costs** - For small/simple graphics
- **Trustless** - Completely self-contained

### Implementation Method
```solidity
// Store SVG as string constant in contract
string private constant BONUS_SVG = 
    '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">'
    '<rect width="400" height="400" fill="#667eea"/>'
    '<text x="200" y="220" text-anchor="middle" font-family="Arial" '
    'font-size="80" fill="white" font-weight="bold">42</text>'
    '</svg>';

// Convert to data URI in tokenURI function
string memory imageURI = string(abi.encodePacked(
    "data:image/svg+xml;base64,",
    Base64.encode(bytes(BONUS_SVG))
));
```

### Optimization Tips
1. **Minimize whitespace** - Remove unnecessary spaces/newlines
2. **Use short color names** - `red` vs `#FF0000`
3. **Combine paths** - Merge similar SVG elements
4. **Avoid gradients** - Use solid colors when possible
5. **Test gas costs** - Large SVGs increase deployment costs

### Data URI Format
```
data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAw...
│    │          │       │
│    │          │       └─ Base64 encoded SVG
│    │          └───────── Encoding type
│    └──────────────────── MIME type  
└───────────────────────── Data URI scheme
```

---

## 🔗 External Resources

### Official Documentation
- **[Solidity Documentation](https://docs.soliditylang.org/)**
- **[OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)**
- **[Foundry Book](https://book.getfoundry.sh/)**
- **[IPFS Documentation](https://docs.ipfs.tech/)**
- **[Pinata API Docs](https://docs.pinata.cloud/)**

### Standards & EIPs
- **[ERC-721 NFT Standard](https://eips.ethereum.org/EIPS/eip-721)**
- **[ERC-165 Interface Detection](https://eips.ethereum.org/EIPS/eip-165)**
- **[JSON Metadata Standard](https://docs.opensea.io/docs/metadata-standards)**

### Tools & Services
- **[MetaMask Developer Docs](https://docs.metamask.io/)**
- **[Sepolia Testnet Faucet](https://sepoliafaucet.com/)**
- **[Etherscan Sepolia](https://sepolia.etherscan.io/)**
- **[SVG Tutorial (MDN)](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial)**

### Community & Learning
- **[Foundry GitHub](https://github.com/foundry-rs/foundry)**
- **[OpenZeppelin Forum](https://forum.openzeppelin.com/)**
- **[Ethereum Stack Exchange](https://ethereum.stackexchange.com/)**

---

Built with ❤️ for 42 School
