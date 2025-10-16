// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Token42NFT is ERC721, Ownable {
    using Strings for uint256;
    
    uint256 private _tokenIdCounter;
    
    // IPFS hash for beautiful SVGs
    string public ipfsHash = "";
    
    // Simple bonus SVG stored onchain
    string private constant BONUS_SVG = '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg"><rect width="400" height="400" fill="#667eea"/><text x="200" y="220" text-anchor="middle" font-family="Arial" font-size="80" fill="white" font-weight="bold">42</text></svg>';
    
    // Track which tokens are which type
    mapping(uint256 => bool) public isBeautifulNFT; // true = beautiful (IPFS), false = bonus (onchain)
    
    constructor() ERC721("42 Art Collection", "42ART") Ownable(msg.sender) {}
    
    // Set IPFS hash for beautiful SVGs
    function setIPFSHash(string memory _ipfsHash) external onlyOwner {
        ipfsHash = _ipfsHash;
    }
    
    // Mint a beautiful SVG (stored on IPFS)
    function mintBeautiful(address to) external {
        uint256 tokenId = _tokenIdCounter++;
        isBeautifulNFT[tokenId] = true;
        _safeMint(to, tokenId);
    }
    
    // Mint a bonus SVG (stored onchain)
    function mintBonus(address to) external {
        uint256 tokenId = _tokenIdCounter++;
        isBeautifulNFT[tokenId] = false;
        _safeMint(to, tokenId);
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        
        string memory imageURI;
        string memory storageType;
        
        if (isBeautifulNFT[tokenId]) {
            // Beautiful SVG from IPFS
            require(bytes(ipfsHash).length > 0, "IPFS hash not set");
            imageURI = string(abi.encodePacked(
                "https://gateway.pinata.cloud/ipfs/",
                ipfsHash,
                "/42NFT_",
                (tokenId % 22 + 1).toString(), // Use tokenId to pick from 1-22
                ".svg"
            ));
            storageType = "Beautiful (IPFS)";
        } else {
            // Bonus SVG onchain
            imageURI = string(abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(bytes(BONUS_SVG))
            ));
            storageType = "Bonus (Onchain)";
        }
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked(
            '{"name": "42 Art #', tokenId.toString(), 
            ' by thi-phng", "description": "Simple 42 art collection", ',
            '"image": "', imageURI, 
            '", "attributes": [',
                '{"trait_type": "Type", "value": "', storageType, '"}, ',
                '{"trait_type": "Artist", "value": "thi-phng"}',
            ']}'
        ))));
        
        return string(abi.encodePacked("data:application/json;base64,", json));
    }
    
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
}
