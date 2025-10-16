// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Token42NFT.sol";

contract Token42NFTTest is Test {
    Token42NFT public nft;
    address public owner = address(1);
    address public minter = address(2);
    
    function setUp() public {
        vm.prank(owner);
        nft = new Token42NFT();
        
        // Set IPFS hash for testing
        vm.prank(owner);
        nft.setIPFSHash("QmTestHashForTesting123456789");
    }
    
    function testMintBeautiful() public {
        // Mint a beautiful NFT
        nft.mintBeautiful(minter);
        
        // Check that token was minted
        assertEq(nft.totalSupply(), 1);
        assertEq(nft.balanceOf(minter), 1);
        
        // Check that it's marked as beautiful
        assertTrue(nft.isBeautifulNFT(0));
        
        // Test token URI generation
        string memory tokenURI = nft.tokenURI(0);
        assertTrue(bytes(tokenURI).length > 0);
    }
    
    function testMintBonus() public {
        // Mint a bonus NFT
        nft.mintBonus(minter);
        
        // Check that token was minted
        assertEq(nft.totalSupply(), 1);
        assertEq(nft.balanceOf(minter), 1);
        
        // Check that it's marked as bonus (not beautiful)
        assertFalse(nft.isBeautifulNFT(0));
        
        // Test token URI generation
        string memory tokenURI = nft.tokenURI(0);
        assertTrue(bytes(tokenURI).length > 0);
    }
    
    function testIPFSHashUpdate() public {
        string memory newHash = "QmNewTestHash987654321";
        
        vm.prank(owner);
        nft.setIPFSHash(newHash);
        
        // Mint a beautiful NFT
        nft.mintBeautiful(minter);
        
        // Check that the token URI works
        string memory tokenURI = nft.tokenURI(0);
        assertTrue(bytes(tokenURI).length > 0);
    }
    
    function testAccessControl() public {
        // Only owner should be able to set IPFS hash
        vm.prank(minter);
        vm.expectRevert();
        nft.setIPFSHash("QmShouldFail");
        
        // Owner should be able to update
        vm.prank(owner);
        nft.setIPFSHash("QmShouldWork");
    }
    
    function testMixedMinting() public {
        // Mint both types
        nft.mintBeautiful(minter);
        nft.mintBonus(minter);
        
        assertEq(nft.totalSupply(), 2);
        assertEq(nft.balanceOf(minter), 2);
        
        // Check types
        assertTrue(nft.isBeautifulNFT(0));  // First is beautiful
        assertFalse(nft.isBeautifulNFT(1)); // Second is bonus
        
        // Both should have valid token URIs
        assertTrue(bytes(nft.tokenURI(0)).length > 0);
        assertTrue(bytes(nft.tokenURI(1)).length > 0);
    }
    
}
