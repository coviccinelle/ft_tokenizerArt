# 🗄️ File Storage Guide for Your NFT

## 🎯 **Quick Answer: Use Pinata**

For your 42 project, **Pinata** is the best choice because:
- ✅ **Beginner-friendly**: Simple web interface
- ✅ **Free**: 1GB storage (plenty for images)
- ✅ **Reliable**: Used by major NFT projects
- ✅ **Fast setup**: Ready in 5 minutes

---

## 🔧 **Infura vs Pinata - What's the Difference?**

| Service | Purpose | What It Does | Why You Need It |
|---------|---------|--------------|-----------------|
| **Infura** | Blockchain Access | Connects to Ethereum network | Deploy contracts, send transactions |
| **Pinata** | File Storage | Stores your images/metadata on IPFS | Permanent, decentralized file hosting |

### **Simple Analogy:**
- **Infura** = Your internet connection to Ethereum
- **Pinata** = Your cloud storage for files

---

## 📁 **Where to Store Your SVG: Complete Options**

### **🥇 Option 1: Pinata (Recommended)**

**Best for**: Beginners, simple projects, reliable storage

**Setup (5 minutes):**
1. Go to https://pinata.cloud/
2. Sign up with email
3. Verify email
4. Ready to upload!

**Upload Process:**
1. Click "Upload" button
2. Choose "File" 
3. Select your SVG file
4. Wait for upload (usually instant)
5. Copy the IPFS hash (looks like: `QmXXXXXXXXXXXXXXXX`)

**Cost**: FREE (1GB storage, unlimited downloads)

---

### **🥈 Option 2: Web3.Storage**

**Best for**: Developers who want free permanent storage

**Setup:**
1. Go to https://web3.storage/
2. Sign up with email or GitHub
3. Get API token

**Upload via Web Interface:**
1. Go to "Files" tab
2. Drag & drop your SVG
3. Get IPFS hash

**Upload via API (optional):**
```javascript
import { Web3Storage } from 'web3.storage'

const client = new Web3Storage({ token: 'YOUR_API_TOKEN' })
const files = [new File(['your SVG content'], '42-art.svg')]
const cid = await client.put(files)
```

**Cost**: FREE (unlimited storage!)

---

### **🥉 Option 3: IPFS Desktop**

**Best for**: Advanced users who want full control

**Setup:**
1. Download IPFS Desktop from https://github.com/ipfs/ipfs-desktop
2. Install and run
3. IPFS node runs locally

**Upload:**
1. Open IPFS Desktop
2. Go to "Files" tab
3. Click "Import" → "File"
4. Select your SVG
5. Get hash from the interface

**Pros**: Full control, no third party
**Cons**: Need to keep your node running for availability

---

### **🏆 Option 4: NFT.Storage**

**Best for**: NFT-specific storage (optimized for NFTs)

**Setup:**
1. Go to https://nft.storage/
2. Sign up for free
3. Get API key

**Features:**
- ✅ **NFT-optimized**: Built specifically for NFT metadata
- ✅ **Free**: Unlimited storage
- ✅ **Permanent**: Backed by Filecoin

---

## 🎨 **SVG File Considerations**

### **Why SVG is Great for NFTs:**
```
Traditional Images:  Fixed resolution, larger files
SVG:                Vector-based, small files, infinite zoom
```

### **SVG Advantages:**
- ✅ **Scalable**: Looks perfect at any size
- ✅ **Small**: Usually under 50KB
- ✅ **Editable**: Can modify with code
- ✅ **Sharp**: Always crisp

### **Example SVG Features You Can Add:**
```svg
<!-- Animations -->
<animateTransform attributeName="transform" type="rotate" 
                  values="0;360" dur="10s" repeatCount="indefinite"/>

<!-- Interactive elements -->
<circle r="50" fill="blue">
  <animate attributeName="fill" values="blue;red;blue" dur="2s" repeatCount="indefinite"/>
</circle>
```

---

## 📋 **Step-by-Step: Pinata Upload**

### **1. Create Account (2 minutes)**
- Go to https://pinata.cloud/
- Click "Get Started"
- Enter email & password
- Verify email

### **2. Upload SVG (1 minute)**
- Click "Upload +" button
- Select "File"
- Choose your SVG file
- Add name/description (optional)
- Click "Upload"

### **3. Get IPFS Hash**
- Copy the hash: `QmYourHashHere`
- Your file is now at: `ipfs://QmYourHashHere`
- Also accessible via: `https://gateway.pinata.cloud/ipfs/QmYourHashHere`

### **4. Test Access**
- Open: `https://gateway.pinata.cloud/ipfs/QmYourHashHere`
- Should see your SVG displayed

---

## 🔗 **Using Your IPFS Hash**

### **In Your Metadata JSON:**
```json
{
  "name": "42 Token Art by thi-phng",
  "description": "My unique 42 school NFT",
  "image": "ipfs://QmYourImageHashHere",
  "attributes": [...]
}
```

### **In Your Mint Script:**
```javascript
// Replace this line in scripts/mint.js
const metadataURI = "ipfs://QmYourMetadataHashHere";
```

---

## 🚨 **Important Notes**

### **File Permanence:**
- **Pinata**: Files stay as long as account is active
- **Web3.Storage**: Permanent storage guaranteed
- **IPFS Desktop**: Only while your node runs

### **Best Practice:**
1. **Pin to multiple services** for redundancy
2. **Keep backups** of your files locally
3. **Save all hashes** in your documentation

### **For 42 School Project:**
- Pinata is perfect and meets all requirements
- Free tier is more than sufficient
- Professional and reliable service

---

## 🎯 **Quick Start Recommendation**

1. **Create your SVG** (use the example I provided as a starting point)
2. **Sign up for Pinata** (5 minutes)
3. **Upload SVG to Pinata** (1 minute)
4. **Save the IPFS hash** 
5. **Create metadata JSON with the hash**
6. **Upload metadata to Pinata**
7. **Use metadata hash in your mint script**

This gives you a complete, professional NFT storage setup!
