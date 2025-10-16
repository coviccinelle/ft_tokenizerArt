// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../code/src/Token42NFT.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy the Token42NFT contract
        Token42NFT token42NFT = new Token42NFT();
        
        console.log("🚀 Token42NFT deployed to:", address(token42NFT));
        console.log("📄 Contract name:", token42NFT.name());
        console.log("🔤 Contract symbol:", token42NFT.symbol());
        console.log("📊 Max supply:", token42NFT.MAX_SUPPLY());
        console.log("💰 Mint price:", token42NFT.MINT_PRICE());
        console.log("👤 Owner:", token42NFT.owner());
        
        vm.stopBroadcast();
        
        // Save deployment info to current deployment folder
        string memory contractAddress = vm.toString(address(token42NFT));
        string memory network = vm.toString(block.chainid);
        string memory deploymentInfo = string(abi.encodePacked(
            "Contract Address: ", contractAddress, "\n",
            "Network Chain ID: ", network, "\n",
            "Deployed by: Deploy.s.sol script\n",
            "Contract: Token42NFT\n",
            "\n",
            "Next step: Add this to your .env file:\n",
            "CONTRACT_ADDRESS=", contractAddress, "\n"
        ));
        
        vm.writeFile("./contract-address.txt", deploymentInfo);
        console.log("💾 Contract address saved to deployment/contract-address.txt");
        console.log("🎯 Next: Add CONTRACT_ADDRESS to .env file");
    }
}