const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

// NFT Metadata (you'll need to upload your image to IPFS first)
const NFT_METADATA = {
  name: "42 Token Art by thi-phng",
  description: "A unique NFT created for the 42 school TokenizerArt project. This artwork features the iconic number 42 and represents my journey in blockchain development.",
  image: "ipfs://YOUR_IPFS_HASH_HERE", // Replace with your IPFS hash
  attributes: [
    {
      trait_type: "Artist",
      value: "thi-phng"
    },
    {
      trait_type: "School",
      value: "42"
    },
    {
      trait_type: "Project",
      value: "ft_tokenizerArt"
    },
    {
      trait_type: "Number",
      value: "42"
    },
    {
      trait_type: "Standard",
      value: "ERC-721"
    },
    {
      trait_type: "Blockchain",
      value: "Ethereum"
    }
  ]
};

async function main() {
  console.log("🎨 Starting NFT minting process...");
  
  // Load deployment info
  const networkName = hardhat.network.name;
  const deploymentPath = path.join(__dirname, `../../deployment/deployment-${networkName}.json`);
  
  if (!fs.existsSync(deploymentPath)) {
    throw new Error(`Deployment file not found for network: ${networkName}. Please deploy the contract first.`);
  }
  
  const deploymentInfo = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
  console.log("Loading contract from:", deploymentInfo.contractAddress);
  
  // Get the contract
  const [signer] = await ethers.getSigners();
  const Token42NFT = await ethers.getContractFactory("Token42NFT");
  const contract = Token42NFT.attach(deploymentInfo.contractAddress);
  
  console.log("Minting NFT to:", signer.address);
  
  // Upload metadata to IPFS (for this example, we'll use a placeholder)
  // In a real scenario, you would upload to IPFS and get the hash
  const metadataURI = "ipfs://QmYourMetadataHashHere"; // Replace with actual IPFS hash
  
  // Mint the NFT
  console.log("Minting NFT...");
  const tx = await contract.ownerMint(signer.address, metadataURI);
  console.log("Transaction hash:", tx.hash);
  
  // Wait for confirmation
  const receipt = await tx.wait();
  console.log("✅ NFT minted successfully!");
  console.log("Gas used:", receipt.gasUsed.toString());
  
  // Get the token ID from the event
  const mintEvent = receipt.events?.find(event => event.event === 'NFTMinted');
  const tokenId = mintEvent?.args?.tokenId;
  
  console.log("Token ID:", tokenId?.toString());
  
  // Verify ownership
  const owner = await contract.ownerOf(tokenId);
  console.log("NFT Owner:", owner);
  console.log("Token URI:", await contract.tokenURI(tokenId));
  
  // Save minting info
  const mintInfo = {
    network: networkName,
    contractAddress: deploymentInfo.contractAddress,
    tokenId: tokenId?.toString(),
    owner: owner,
    metadataURI: metadataURI,
    transactionHash: tx.hash,
    blockNumber: receipt.blockNumber,
    mintTime: new Date().toISOString(),
    metadata: NFT_METADATA
  };
  
  const mintDir = path.join(__dirname, '../');
  fs.writeFileSync(
    path.join(mintDir, `mint-${networkName}-${tokenId}.json`),
    JSON.stringify(mintInfo, null, 2)
  );
  
  console.log("💾 Mint info saved to mint folder");
  
  return { tokenId, owner, transactionHash: tx.hash };
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Minting failed:", error);
    process.exit(1);
  });
