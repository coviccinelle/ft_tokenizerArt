const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Starting deployment of Token42NFT...");
  
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  
  // Check deployer balance
  const balance = await deployer.getBalance();
  console.log("Account balance:", ethers.utils.formatEther(balance), "ETH");
  
  // Deploy the contract
  const Token42NFT = await ethers.getContractFactory("Token42NFT");
  console.log("Deploying Token42NFT contract...");
  
  const token42NFT = await Token42NFT.deploy(deployer.address);
  await token42NFT.deployed();
  
  console.log("✅ Token42NFT deployed to:", token42NFT.address);
  console.log("Contract owner:", await token42NFT.owner());
  
  // Verify contract deployment
  console.log("Contract name:", await token42NFT.name());
  console.log("Contract symbol:", await token42NFT.symbol());
  console.log("Max supply:", await token42NFT.MAX_SUPPLY());
  console.log("Current supply:", await token42NFT.totalSupply());
  
  // Save deployment info
  const deploymentInfo = {
    network: hardhat.network.name,
    contractAddress: token42NFT.address,
    deployerAddress: deployer.address,
    deploymentTime: new Date().toISOString(),
    transactionHash: token42NFT.deployTransaction.hash,
    blockNumber: token42NFT.deployTransaction.blockNumber
  };
  
  console.log("\n📄 Deployment Summary:");
  console.log("Network:", deploymentInfo.network);
  console.log("Contract Address:", deploymentInfo.contractAddress);
  console.log("Transaction Hash:", deploymentInfo.transactionHash);
  console.log("Block Number:", deploymentInfo.blockNumber);
  
  // Save to file
  const fs = require('fs');
  const path = require('path');
  
  const deploymentDir = path.join(__dirname, '../');
  if (!fs.existsSync(deploymentDir)) {
    fs.mkdirSync(deploymentDir, { recursive: true });
  }
  
  fs.writeFileSync(
    path.join(deploymentDir, `deployment-${deploymentInfo.network}.json`),
    JSON.stringify(deploymentInfo, null, 2)
  );
  
  console.log("💾 Deployment info saved to deployment folder");
  
  return token42NFT;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
