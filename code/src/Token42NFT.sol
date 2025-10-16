// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/src/console.sol";
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
        
        // ...existing code...
        
        // Adding 19 more designs for a total of 22
        svgDesigns[3] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#2c3e50"/><polygon points="200,50 350,350 50,350" fill="#3498db"/><text x="200" y="220" text-anchor="middle" font-family="Arial" font-size="70" fill="white">42</text></svg>';
        
        svgDesigns[4] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#8e44ad"/><circle cx="200" cy="200" r="100" fill="#9b59b6"/><text x="200" y="215" text-anchor="middle" font-family="Arial" font-size="60" fill="white">42</text></svg>';
        
        // Initialize remaining designs (5-21) with variations...
        for (uint i = 5; i < 22; i++) {
            svgDesigns[i] = string(abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="hsl(',
                (i * 17).toString(), ', 70%, 50%)"/><text x="200" y="220" text-anchor="middle" font-family="Arial" font-size="80" fill="white" font-weight="bold">42</text></svg>'
            ));
        }
    }
    
    function mint() external payable {
        require(_tokenIdCounter < MAX_SUPPLY, "Max supply reached");
        require(msg.value >= MINT_PRICE, "Insufficient payment");
        
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        
        // Generate pseudo-random design (0-21)
        uint256 designId = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.prevrandao,
            msg.sender,
            tokenId
        ))) % 22;
        
        tokenToDesign[tokenId] = designId;
        _safeMint(msg.sender, tokenId);
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        
        uint256 designId = tokenToDesign[tokenId];
        string memory svg = svgDesigns[designId];
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked(
            '{"name": "42 Art #', tokenId.toString(), 
            ' by thi-phng", "description": "On-chain generative 42 art collection for 42 school project", ',
            '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(svg)), 
            '", "attributes": [{"trait_type": "Design", "value": "', designId.toString(), 
            '"}, {"trait_type": "Artist", "value": "thi-phng"}, {"trait_type": "School", "value": "42"}]}'
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
