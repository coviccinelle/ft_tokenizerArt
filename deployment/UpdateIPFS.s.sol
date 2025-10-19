// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "src/Token42NFT.sol";

contract UpdateIPFSScript is Script {
    // New IPFS hash for beautiful folder
    string constant NEW_IPFS_HASH = "bafybeifuat6mqtsgaotpz2cdw6botsxdgggaicflcrqxgentiic5kec6ze";

    function run() external {
        // Read deployed contract address from environment
        address deployed = vm.envAddress("CONTRACT_ADDRESS");
        require(deployed != address(0), "CONTRACT_ADDRESS not set in env");

        vm.startBroadcast();

        Token42NFT nft = Token42NFT(deployed);

        // Update IPFS hash -> beautiful folder
        nft.setIPFSHash(NEW_IPFS_HASH);

        console.log("IPFS hash updated to:", NEW_IPFS_HASH);
        console.log("Contract address:", deployed);

        vm.stopBroadcast();
    }
}
