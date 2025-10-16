const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
  console.log("🎨 Starting NFT minting process...");
  
  // Get the deployer account
  const [signer] = await ethers.getSigners();
  console.log("Minting NFT to:", signer.address);
  
  // You need to set this to your deployed contract address
  const CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS_HERE"; // Replace after deployment
  
  if (CONTRACT_ADDRESS === "YOUR_CONTRACT_ADDRESS_HERE") {
    throw new Error("Please update CONTRACT_ADDRESS in scripts/mint.js with your deployed contract address");
  }
  
  // Get the contract
  const Token42NFT = await ethers.getContractFactory("Token42NFT");
  const contract = Token42NFT.attach(CONTRACT_ADDRESS);
  
  // Check mint price
  const mintPrice = await contract.MINT_PRICE();
  console.log("Mint price:", ethers.formatEther(mintPrice), "ETH");
  
  // Mint NFT
  console.log("Minting NFT...");
  const tx = await contract.mint({ value: mintPrice });
  console.log("Transaction hash:", tx.hash);
  
  // Wait for confirmation
  const receipt = await tx.wait();
  console.log("✅ NFT minted successfully!");
  console.log("Gas used:", receipt.gasUsed.toString());
  
  // Get the token ID from the event
  const transferEvent = receipt.logs.find(log => {
    try {
      return contract.interface.parseLog(log).name === 'Transfer';
    } catch (e) {
      return false;
    }
  });
  
  if (transferEvent) {
    const parsedLog = contract.interface.parseLog(transferEvent);
    const tokenId = parsedLog.args.tokenId;
    console.log("Token ID:", tokenId.toString());
    
    // Verify ownership
    const owner = await contract.ownerOf(tokenId);
    console.log("NFT Owner:", owner);
    console.log("Token URI:", await contract.tokenURI(tokenId));
  }
  
  // Get current supply
  const totalSupply = await contract.totalSupply();
  console.log("Total supply:", totalSupply.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Minting failed:", error);
    process.exit(1);
  });
