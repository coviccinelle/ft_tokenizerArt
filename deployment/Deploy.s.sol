// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "src/Token42NFT.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        
        Token42NFT nft = new Token42NFT();
        
        console.log("Token42NFT deployed to:", address(nft));
        
        vm.stopBroadcast();
    }
}