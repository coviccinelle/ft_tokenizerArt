// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Token42NFT is ERC721, Ownable {
    using Strings for uint256;
    
    uint256 private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MINT_PRICE = 0.001 ether;
    
    // Store 22 different SVG designs on-chain
    string[22] private svgDesigns;
    
    mapping(uint256 => uint256) private tokenToDesign;
    
    constructor() ERC721("42 Art Collection", "42ART") Ownable(msg.sender) {
        initializeSVGs();
    }
    
    function initializeSVGs() private {
        // 22 different minimalist SVG designs with "42"
        svgDesigns[0] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#1a1a2e"/><text x="200" y="220" text-anchor="middle" font-family="Arial" font-size="80" fill="#16213e" font-weight="bold">42</text><circle cx="200" cy="200" r="150" fill="none" stroke="#0f3460" stroke-width="4"/></svg>';
        
        svgDesigns[1] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#0f0f23"/><text x="200" y="220" text-anchor="middle" font-family="monospace" font-size="100" fill="#ffff00">42</text><rect x="100" y="100" width="200" height="200" fill="none" stroke="#333" stroke-width="2"/></svg>';
        
        svgDesigns[2] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><defs><radialGradient id="grad1"><stop offset="0%" stop-color="#ff6b6b"/><stop offset="100%" stop-color="#4ecdc4"/></radialGradient></defs><rect width="400" height="400" fill="url(#grad1)"/><text x="200" y="220" text-anchor="middle" font-family="Arial" font-size="90" fill="white" font-weight="bold">42</text></svg>';
        
        svgDesigns[3] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#2c3e50"/><polygon points="200,50 350,350 50,350" fill="#3498db"/><text x="200" y="220" text-anchor="middle" font-family="Arial" font-size="70" fill="white">42</text></svg>';
        
        svgDesigns[4] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#8e44ad"/><circle cx="200" cy="200" r="100" fill="#9b59b6"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        svgDesigns[5] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#34495e"/><rect x="150" y="150" width="100" height="100" fill="#e74c3c"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="50" fill="white">42</text></svg>';
        
        svgDesigns[6] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#1abc9c"/><ellipse cx="200" cy="200" rx="150" ry="80" fill="#16a085"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="70" fill="white">42</text></svg>';
        
        svgDesigns[7] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#f39c12"/><path d="M200 100 L300 200 L200 300 L100 200 Z" fill="#e67e22"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        svgDesigns[8] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#2ecc71"/><polygon points="200,80 320,160 280,280 120,280 80,160" fill="#27ae60"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="70" fill="white">42</text></svg>';
        
        svgDesigns[9] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#e74c3c"/><circle cx="200" cy="200" r="120" fill="#c0392b"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="80" fill="white">42</text></svg>';
        
        svgDesigns[10] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#9b59b6"/><rect x="100" y="100" width="200" height="200" fill="#8e44ad" transform="rotate(45 200 200)"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        svgDesigns[11] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#34495e"/><circle cx="150" cy="150" r="40" fill="#3498db"/><circle cx="250" cy="150" r="40" fill="#e74c3c"/><circle cx="200" cy="250" r="40" fill="#2ecc71"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="50" fill="white">42</text></svg>';
        
        svgDesigns[12] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#16a085"/><path d="M200 50 Q350 200 200 350 Q50 200 200 50" fill="#1abc9c"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="70" fill="white">42</text></svg>';
        
        svgDesigns[13] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#d35400"/><polygon points="200,100 280,140 320,220 280,260 200,300 120,260 80,220 120,140" fill="#e67e22"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        svgDesigns[14] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#7f8c8d"/><ellipse cx="200" cy="200" rx="100" ry="150" fill="#95a5a6"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="70" fill="white">42</text></svg>';
        
        svgDesigns[15] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#c0392b"/><rect x="150" y="100" width="100" height="200" fill="#e74c3c"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        svgDesigns[16] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#27ae60"/><circle cx="200" cy="200" r="80" fill="#2ecc71"/><circle cx="200" cy="200" r="120" fill="none" stroke="#34495e" stroke-width="4"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="50" fill="white">42</text></svg>';
        
        svgDesigns[17] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#8e44ad"/><path d="M100 200 Q200 100 300 200 Q200 300 100 200" fill="#9b59b6"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        svgDesigns[18] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#2c3e50"/><polygon points="200,120 260,180 200,240 140,180" fill="#3498db"/><polygon points="200,160 220,180 200,200 180,180" fill="#2980b9"/><text x="200" y="285" text-anchor="middle" font-family="Arial" font-size="50" fill="white">42</text></svg>';
        
        svgDesigns[19] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#e67e22"/><circle cx="120" cy="200" r="60" fill="#f39c12"/><circle cx="280" cy="200" r="60" fill="#f39c12"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="70" fill="white">42</text></svg>';
        
        svgDesigns[20] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#1abc9c"/><rect x="100" y="160" width="200" height="80" fill="#16a085" rx="40"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        svgDesigns[21] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#95a5a6"/><polygon points="200,80 320,200 200,320 80,200" fill="#7f8c8d"/><circle cx="200" cy="200" r="50" fill="#34495e"/><text x="200" y="210" text-anchor="middle" font-family="Arial" font-size="30" fill="white">42</text></svg>';
    }
    
    function mint() external payable {
        require(_tokenIdCounter < MAX_SUPPLY, "Max supply reached");
        require(msg.value >= MINT_PRICE, "Insufficient payment");
        
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        
        // Generate pseudo-random design (0-21)
        uint256 designId = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.difficulty,
            msg.sender,
            tokenId
        ))) % 22;
        
        tokenToDesign[tokenId] = designId;
        _safeMint(msg.sender, tokenId);
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        
        uint256 designId = tokenToDesign[tokenId];
        string memory svg = svgDesigns[designId];
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked(
            '{"name": "42 Art #', tokenId.toString(), 
            '", "description": "On-chain generative 42 art collection", ',
            '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(svg)), 
            '", "attributes": [{"trait_type": "Design", "value": "', designId.toString(), '"}]}'
        ))));
        
        return string(abi.encodePacked("data:application/json;base64,", json));
    }
    
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
    
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
