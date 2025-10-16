// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../code/src/Token42NFT.sol";

contract MintScript is Script {
    function run() external {
        address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
        address recipient = vm.envAddress("RECIPIENT_ADDRESS");
        string memory mintType = vm.envString("MINT_TYPE"); // "beautiful" or "bonus"
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        Token42NFT nft = Token42NFT(contractAddress);
        
        if (keccak256(bytes(mintType)) == keccak256(bytes("beautiful"))) {
            nft.mintBeautiful(recipient);
            console.log("Minted beautiful NFT to:", recipient);
        } else {
            nft.mintBonus(recipient);
            console.log("Minted bonus NFT to:", recipient);
        }
        
        console.log("Total supply:", nft.totalSupply());
        
        vm.stopBroadcast();
    }
}
