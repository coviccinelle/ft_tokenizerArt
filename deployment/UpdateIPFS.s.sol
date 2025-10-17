// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "src/Token42NFT.sol";

contract UpdateIPFSScript is Script {
    // Deployed contract address on Sepolia
    address constant DEPLOYED_CONTRACT = 0xFcE8134d569F41Fb05b52A081B9197840148caaf;
    
    // New IPFS hash for beautiful folder
    string constant NEW_IPFS_HASH = "bafybeifuat6mqtsgaotpz2cdw6botsxdgggaicflcrqxgentiic5kec6ze";
    
    function run() external {
        vm.startBroadcast();
        
        Token42NFT nft = Token42NFT(DEPLOYED_CONTRACT);
        
        // Update IPFS hash -> beautiful folder
        nft.setIPFSHash(NEW_IPFS_HASH);
        
        console.log("IPFS hash updated to:", NEW_IPFS_HASH);
        console.log("Contract address:", DEPLOYED_CONTRACT);
        
        vm.stopBroadcast();
    }
}
