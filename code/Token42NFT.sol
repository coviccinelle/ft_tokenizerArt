// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Token42NFT
 * @dev A simple ERC-721 NFT contract for the 42 school project
 * @author thi-phng (42 login) - Artist name for metadata
 */
contract Token42NFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    
    // Counter for token IDs
    Counters.Counter private _tokenIdCounter;
    
    // Maximum supply of NFTs
    uint256 public constant MAX_SUPPLY = 42;
    
    // Price per NFT (in wei) - set to 0 for free minting on testnet
    uint256 public mintPrice = 0;
    
    // Events
    event NFTMinted(address indexed to, uint256 indexed tokenId, string tokenURI);
    
    constructor(address initialOwner) 
        ERC721("Token42Art", "T42A") 
        Ownable(initialOwner)
    {
        // Start token IDs at 1
        _tokenIdCounter.increment();
    }
    
    /**
     * @dev Mints a new NFT to the specified address
     * @param to The address to mint the NFT to
     * @param tokenURI The metadata URI for the NFT
     */
    function mintNFT(address to, string memory tokenURI) 
        public 
        payable 
        returns (uint256) 
    {
        require(msg.value >= mintPrice, "Insufficient payment");
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "Max supply reached");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        
        emit NFTMinted(to, tokenId, tokenURI);
        
        return tokenId;
    }
    
    /**
     * @dev Owner can mint NFTs for free
     * @param to The address to mint the NFT to
     * @param tokenURI The metadata URI for the NFT
     */
    function ownerMint(address to, string memory tokenURI) 
        public 
        onlyOwner 
        returns (uint256) 
    {
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "Max supply reached");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        
        emit NFTMinted(to, tokenId, tokenURI);
        
        return tokenId;
    }
    
    /**
     * @dev Returns the total number of tokens minted
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current() - 1;
    }
    
    /**
     * @dev Updates the mint price (only owner)
     * @param newPrice The new price in wei
     */
    function setMintPrice(uint256 newPrice) public onlyOwner {
        mintPrice = newPrice;
    }
    
    /**
     * @dev Withdraws contract balance to owner
     */
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Withdrawal failed");
    }
    
    // Override required functions
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
    function _burn(uint256 tokenId) 
        internal 
        override(ERC721, ERC721URIStorage) 
    {
        super._burn(tokenId);
    }
}
