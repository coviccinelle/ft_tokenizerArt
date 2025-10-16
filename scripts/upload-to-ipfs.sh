#!/bin/bash

# IPFS Upload Script for 42 NFT Art Collection
# This script uploads the large SVG files to IPFS and provides instructions for Pinata pinning

echo "🚀 42 NFT Art - IPFS Upload Script"
echo "=================================="

# Check if IPFS is installed
if ! command -v ipfs &> /dev/null; then
    echo "❌ IPFS CLI not found. Please install IPFS first:"
    echo "   Visit: https://docs.ipfs.io/install/command-line/"
    exit 1
fi

# Create temporary directory for IPFS upload
UPLOAD_DIR="ipfs-upload-$(date +%s)"
mkdir -p "$UPLOAD_DIR"

echo "📁 Copying large SVG files to upload directory..."

# Copy all the large SVG files (excluding bonusNFT.svg which is stored onchain)
for i in {1..22}; do
    if [ -f "SVGs/42NFT_${i}.svg" ]; then
        cp "SVGs/42NFT_${i}.svg" "$UPLOAD_DIR/"
        echo "   ✓ Copied 42NFT_${i}.svg"
    else
        echo "   ⚠️  Warning: 42NFT_${i}.svg not found"
    fi
done

echo ""
echo "📊 Upload directory contents:"
ls -lh "$UPLOAD_DIR"

echo ""
echo "🌐 Adding to IPFS..."

# Add the directory to IPFS
IPFS_RESULT=$(ipfs add -r "$UPLOAD_DIR" | tail -n 1)
IPFS_HASH=$(echo "$IPFS_RESULT" | awk '{print $2}')

echo "✅ Upload complete!"
echo "📋 IPFS Hash: $IPFS_HASH"
echo ""

# Create a summary file
cat > ipfs-upload-summary.txt << EOF
42 NFT Art Collection - IPFS Upload Summary
==========================================

Upload Date: $(date)
IPFS Hash: $IPFS_HASH
Files Uploaded: $(ls "$UPLOAD_DIR" | wc -l) SVG files

Gateway URLs:
- IPFS.io: https://ipfs.io/ipfs/$IPFS_HASH
- Cloudflare: https://cloudflare-ipfs.com/ipfs/$IPFS_HASH
- Pinata: https://gateway.pinata.cloud/ipfs/$IPFS_HASH

Individual File URLs (examples):
- 42NFT_1.svg: https://gateway.pinata.cloud/ipfs/$IPFS_HASH/42NFT_1.svg
- 42NFT_2.svg: https://gateway.pinata.cloud/ipfs/$IPFS_HASH/42NFT_2.svg
- ...and so on

Smart Contract Setup:
=====================
After deploying your contract, call:
contract.setIPFSHash("$IPFS_HASH");

Files included in this upload:
EOF

ls "$UPLOAD_DIR" >> ipfs-upload-summary.txt

echo "📄 Summary saved to: ipfs-upload-summary.txt"
echo ""
echo "🔧 Next Steps:"
echo "1. Pin this hash on Pinata: https://www.pinata.cloud/"
echo "2. Deploy your smart contract"
echo "3. Call setIPFSHash(\"$IPFS_HASH\") on your deployed contract"
echo "4. Test a few token URLs to ensure they work"
echo ""
echo "🧹 Cleanup: You can safely delete the '$UPLOAD_DIR' directory after confirming upload"

echo ""
echo "🎨 Example token metadata preview:"
echo "Token with Design ID 0 (42NFT_1.svg) will have image URL:"
echo "https://gateway.pinata.cloud/ipfs/$IPFS_HASH/42NFT_1.svg"
echo ""
echo "Token with Design ID 22 (bonus) will have onchain SVG data"
