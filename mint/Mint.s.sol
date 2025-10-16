// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../code/src/Token42NFT.sol";

contract MintScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Get contract address from .env file
        address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
        
        // Check if contract address is set
        require(contractAddress != address(0), "CONTRACT_ADDRESS not set in .env file");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Connect to the deployed contract
        Token42NFT token42NFT = Token42NFT(contractAddress);
        
        console.log("🎨 Starting NFT minting process...");
        console.log("📍 Contract address:", contractAddress);
        console.log("💰 Mint price:", token42NFT.MINT_PRICE());
        
        // Mint NFT
        uint256 mintPrice = token42NFT.MINT_PRICE();
        token42NFT.mint{value: mintPrice}();
        
        console.log("✅ NFT minted successfully!");
        
        // Get current supply
        uint256 totalSupply = token42NFT.totalSupply();
        console.log("📊 Total supply:", totalSupply);
        console.log("🎯 Your token ID:", totalSupply - 1);
        
        vm.stopBroadcast();
        
        // Save mint info to current mint folder
        string memory mintInfo = string(abi.encodePacked(
            "NFT Minted Successfully!\n",
            "Contract: ", vm.toString(contractAddress), "\n",
            "Token ID: ", vm.toString(totalSupply - 1), "\n",
            "Total Supply: ", vm.toString(totalSupply), "\n",
            "Minted by: Mint.s.sol script\n",
            "Network Chain ID: ", vm.toString(block.chainid), "\n"
        ));
        
        vm.writeFile("./mint-info.txt", mintInfo);
        console.log("💾 Mint info saved to mint/mint-info.txt");
    }
}