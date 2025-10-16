const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
  console.log("🚀 Starting deployment of Token42NFT...");
  
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  
  // Check deployer balance
  const balance = await deployer.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "ETH");
  
  // Deploy the contract
  const Token42NFT = await ethers.getContractFactory("Token42NFT");
  console.log("Deploying Token42NFT contract...");
  
  const contract = await Token42NFT.deploy();
  await contract.waitForDeployment();
  const contractAddress = await contract.getAddress();
  
  console.log("✅ Token42NFT deployed to:", contractAddress);
  console.log("Network:", network.name);
  
  // Verify contract deployment
  console.log("Contract name:", await contract.name());
  console.log("Contract symbol:", await contract.symbol());
  console.log("Max supply:", await contract.MAX_SUPPLY());
  console.log("Current supply:", await contract.totalSupply());
  
  // Save deployment info to a simple file
  const deploymentInfo = {
    network: network.name,
    contractAddress: contractAddress,
    deployerAddress: deployer.address,
    deploymentTime: new Date().toISOString(),
    transactionHash: contract.deploymentTransaction().hash
  };
  
  console.log("\n📄 Deployment Summary:");
  console.log("Network:", deploymentInfo.network);
  console.log("Contract Address:", deploymentInfo.contractAddress);
  console.log("Transaction Hash:", deploymentInfo.transactionHash);
  
  // Save contract address to root directory
  fs.writeFileSync(
    path.join(__dirname, '../../contract-address.txt'),
    `Contract Address: ${contractAddress}\nNetwork: ${network.name}\nDeployed: ${deploymentInfo.deploymentTime}`
  );
  
  console.log("💾 Contract address saved to contract-address.txt");
  console.log("\n🎯 Next step: Update CONTRACT_ADDRESS in scripts/mint.js");
  
  return contract;
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
