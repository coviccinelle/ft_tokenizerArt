# 🎨 On-Chain SVG Storage - Complete Guide

## 🤔 What is On-Chain Storage?

On-chain storage means the SVG code is **permanently embedded** in the smart contract on the blockchain, rather than stored on external servers or IPFS.

### Benefits
✅ **Permanent** - Cannot be deleted or changed  
✅ **Decentralized** - No external dependencies  
✅ **Trustless** - Fully self-contained  
✅ **Fast** - No network requests to load images  

### Drawbacks
❌ **Expensive** - Higher gas costs for deployment  
❌ **Limited** - Blockchain storage is costly for large files  
❌ **Immutable** - Cannot update after deployment  

---

## 📏 Size Considerations

### Gas Cost Examples
```
Storage Size → Deployment Cost (rough estimates)
500 bytes   → ~50,000 gas    (~$2-5)
1 KB        → ~100,000 gas   (~$5-10)  
5 KB        → ~500,000 gas   (~$25-50)
10 KB       → ~1,000,000 gas (~$50-100)
```

### Optimization Strategy
- Keep SVGs under **2-3 KB** for reasonable costs
- Use simple shapes and solid colors
- Minimize text and complex paths
- Remove whitespace and comments

---

## 🛠️ Implementation Methods

### Method 1: String Constant (Our Approach)
```solidity
contract Token42NFT is ERC721 {
    string private constant BONUS_SVG = 
        '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">'
        '<rect width="400" height="400" fill="#667eea"/>'
        '<text x="200" y="220" text-anchor="middle" font-family="Arial" '
        'font-size="80" fill="white" font-weight="bold">42</text>'
        '</svg>';
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!isBeautifulNFT[tokenId]) {
            string memory imageURI = string(abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(bytes(BONUS_SVG))
            ));
            // ... rest of metadata generation
        }
    }
}
```

### Method 2: Constructor Parameter
```solidity
contract Token42NFT is ERC721 {
    string private bonusSVG;
    
    constructor(string memory _bonusSVG) ERC721("42 Art", "42ART") {
        bonusSVG = _bonusSVG;  // Set at deployment
    }
}
```

### Method 3: Setter Function (Updateable)
```solidity
contract Token42NFT is ERC721, Ownable {
    string private bonusSVG;
    
    function setBonusSVG(string calldata _svg) external onlyOwner {
        bonusSVG = _svg;  // Owner can update
    }
}
```

---

## 🎯 SVG Optimization Techniques

### 1. Remove Unnecessary Elements
```svg
<!-- Before: Verbose -->
<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <rect x="0" y="0" width="400" height="400" fill="#667eea" />
  <text x="200" y="220" text-anchor="middle" font-family="Arial, sans-serif" 
        font-size="80" font-weight="bold" fill="#ffffff">42</text>
</svg>

<!-- After: Optimized -->
<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
<rect width="400" height="400" fill="#667eea"/>
<text x="200" y="220" text-anchor="middle" font-family="Arial" 
font-size="80" fill="white" font-weight="bold">42</text>
</svg>
```

### 2. Use Short Color Names
```svg
<!-- Instead of -->
fill="#FF0000"    <!-- Use --> fill="red"
fill="#FFFFFF"    <!-- Use --> fill="white" 
fill="#000000"    <!-- Use --> fill="black"
```

### 3. Combine Similar Elements
```svg
<!-- Before: Multiple elements -->
<circle cx="100" cy="100" r="50" fill="blue"/>
<circle cx="200" cy="100" r="50" fill="blue"/>
<circle cx="300" cy="100" r="50" fill="blue"/>

<!-- After: Single group -->
<g fill="blue">
<circle cx="100" cy="100" r="50"/>
<circle cx="200" cy="100" r="50"/>
<circle cx="300" cy="100" r="50"/>
</g>
```

### 4. Minimize Decimal Precision
```svg
<!-- Before -->
<path d="M 12.3456 45.7890 L 98.7654 123.4567"/>

<!-- After -->  
<path d="M 12.3 45.8 L 98.8 123.5"/>
```

---

## 📊 Data URI Encoding

### Understanding the Format
```
data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAw...
│    │          │       │
│    │          │       └─ Base64 encoded SVG content
│    │          └───────── Encoding method (base64)
│    └──────────────────── MIME type for SVG
└───────────────────────── Data URI scheme
```

### Implementation in Solidity
```solidity
import "@openzeppelin/contracts/utils/Base64.sol";

function generateSVGDataURI(string memory svg) internal pure returns (string memory) {
    return string(abi.encodePacked(
        "data:image/svg+xml;base64,",
        Base64.encode(bytes(svg))
    ));
}
```

### Alternative: URL Encoding (Smaller)
```solidity
function generateSVGDataURI(string memory svg) internal pure returns (string memory) {
    // URL encode special characters
    return string(abi.encodePacked(
        "data:image/svg+xml,",
        _urlEncode(svg)
    ));
}
```

---

## 🔧 Testing On-Chain SVGs

### 1. Local Testing
```solidity
// In your test file
function testBonusSVGGeneration() public {
    nft.mintBonus(address(this));
    string memory tokenURI = nft.tokenURI(0);
    
    // Decode and verify
    console.log("Token URI:", tokenURI);
    
    // Check for data URI prefix
    assertTrue(bytes(tokenURI).length > 0);
}
```

### 2. Browser Testing
```javascript
// Paste this in browser console to test SVG
const svgData = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0i...";
const img = document.createElement('img');
img.src = svgData;
document.body.appendChild(img);
```

### 3. Online Validators
- **SVG Validator**: https://validator.w3.org/
- **Base64 Decoder**: https://www.base64decode.org/
- **Data URI Maker**: https://dopiaza.org/tools/datauri/

---

## 🎨 Design Examples

### Simple Geometric
```svg
<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
<rect width="400" height="400" fill="#667eea"/>
<circle cx="200" cy="200" r="100" fill="white" opacity="0.8"/>
<text x="200" y="210" text-anchor="middle" font-size="60" fill="#667eea">42</text>
</svg>
```

### Logo Style
```svg
<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
<rect width="400" height="400" fill="black"/>
<rect x="50" y="100" width="300" height="200" fill="none" stroke="white" stroke-width="4"/>
<text x="200" y="220" text-anchor="middle" font-size="80" fill="white" font-family="monospace">42</text>
</svg>
```

### Gradient Alternative (Simple)
```svg
<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
<rect width="400" height="400" fill="#FF6B6B"/>
<rect width="400" height="200" fill="#4ECDC4" opacity="0.7"/>
<text x="200" y="220" text-anchor="middle" font-size="80" fill="white">42</text>
</svg>
```

---

## ⚡ Advanced Techniques

### Dynamic SVG Generation
```solidity
function generateDynamicSVG(uint256 tokenId) internal pure returns (string memory) {
    // Use tokenId to create variations
    uint256 hue = (tokenId * 137) % 360;  // Golden angle for color variation
    
    return string(abi.encodePacked(
        '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">',
        '<rect width="400" height="400" fill="hsl(', hue.toString(), ',70%,50%)"/>',
        '<text x="200" y="220" text-anchor="middle" font-size="80" fill="white">',
        tokenId.toString(),
        '</text></svg>'
    ));
}
```

### Trait-Based Generation
```solidity
struct SVGTraits {
    string background;
    string textColor;
    uint256 fontSize;
}

function generateTraitSVG(SVGTraits memory traits) internal pure returns (string memory) {
    return string(abi.encodePacked(
        '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">',
        '<rect width="400" height="400" fill="', traits.background, '"/>',
        '<text x="200" y="220" text-anchor="middle" font-size="', 
        traits.fontSize.toString(), '" fill="', traits.textColor, '">42</text>',
        '</svg>'
    ));
}
```

---

## 📚 Additional Resources

### SVG References
- **[SVG MDN Tutorial](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial)**
- **[SVG Optimization Guide](https://web.dev/optimize-svgs/)**
- **[SVGO Optimizer](https://github.com/svg/svgo)**

### On-Chain NFT Examples
- **[Loot](https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7)** - Text-based NFTs
- **[Autoglyphs](https://etherscan.io/address/0xd4e4078ca3495de5b1d4db434bebc5a986197782)** - Generated art
- **[Chain Runners](https://etherscan.io/address/0x97597002980134bea46250aa0510c9b90d87a587)** - Pixel art

### Tools & Libraries
- **[OpenZeppelin Base64](https://docs.openzeppelin.com/contracts/4.x/utilities#base64)**
- **[Hot Chain SVG](https://github.com/w1nt3r-eth/hot-chain-svg)** - On-chain SVG library
- **[SVG-to-TS](https://github.com/kreuzerk/svg-to-ts)** - Convert SVG to code

---

**Pro Tip**: Start simple with basic shapes and text, then gradually add complexity as you optimize for gas costs! 🎨
