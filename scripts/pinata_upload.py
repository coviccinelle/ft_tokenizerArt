import os
import requests
import json
from pathlib import Path

class PinataUploader:
    def __init__(self, api_key, secret_key):
        self.api_key = api_key
        self.secret_key = secret_key
        self.base_url = "https://api.pinata.cloud"
        self.headers = {
            'pinata_api_key': self.api_key,
            'pinata_secret_api_key': self.secret_key
        }
    
    def test_authentication(self):
        """Test if API keys are valid"""
        try:
            response = requests.get(
                f"{self.base_url}/data/testAuthentication",
                headers=self.headers
            )
            return response.status_code == 200
        except Exception as e:
            print(f"Authentication test failed: {e}")
            return False
    
    def upload_folder(self, folder_path, folder_name):
        """Upload a folder to Pinata"""
        try:
            # Prepare files for upload
            files = []
            folder_path = Path(folder_path)
            
            for file_path in folder_path.glob("*.svg"):
                files.append(
                    ('file', (file_path.name, open(file_path, 'rb'), 'image/svg+xml'))
                )
            
            # Metadata for the upload
            metadata = {
                'name': folder_name,
                'keyvalues': {
                    'project': '42_nft_art',
                    'artist': 'thi-phng',
                    'file_count': str(len(files))
                }
            }
            
            data = {
                'pinataMetadata': json.dumps(metadata),
                'pinataOptions': json.dumps({
                    'cidVersion': 1
                })
            }
            
            print(f"📤 Uploading {len(files)} files to Pinata...")
            
            response = requests.post(
                f"{self.base_url}/pinning/pinFileToIPFS",
                files=files,
                data=data,
                headers=self.headers
            )
            
            # Close file handles
            for _, file_tuple in files:
                file_tuple[1].close()
            
            if response.status_code == 200:
                result = response.json()
                return result['IpfsHash']
            else:
                print(f"Upload failed: {response.status_code}")
                print(response.text)
                return None
                
        except Exception as e:
            print(f"Upload error: {e}")
            return None
    
    def list_pins(self):
        """List pinned files"""
        try:
            response = requests.get(
                f"{self.base_url}/data/pinList",
                headers=self.headers
            )
            
            if response.status_code == 200:
                return response.json()
            else:
                print(f"Failed to list pins: {response.status_code}")
                return None
                
        except Exception as e:
            print(f"List pins error: {e}")
            return None

def main():
    print("🎨 42 NFT Art - Pinata Upload Script")
    print("====================================")
    
    # Get API keys from environment or user input
    api_key = os.getenv('PINATA_API_KEY')
    secret_key = os.getenv('PINATA_SECRET_KEY')
    
    if not api_key:
        api_key = input("Enter your Pinata API Key: ")
    if not secret_key:
        secret_key = input("Enter your Pinata Secret Key: ")
    
    uploader = PinataUploader(api_key, secret_key)
    
    # Test authentication
    print("🔐 Testing authentication...")
    if not uploader.test_authentication():
        print("❌ Authentication failed. Please check your API keys.")
        return
    
    print("✅ Authentication successful!")
    
    # Upload SVG files
    svg_folder = "SVGs"
    if not os.path.exists(svg_folder):
        print(f"❌ SVG folder '{svg_folder}' not found.")
        return
    
    # Create a temporary folder with only the large SVGs
    import tempfile
    import shutil
    
    with tempfile.TemporaryDirectory() as temp_dir:
        print("📁 Preparing files for upload...")
        
        # Copy large SVG files (exclude bonusNFT.svg)
        file_count = 0
        for i in range(1, 23):
            src_file = f"{svg_folder}/42NFT_{i}.svg"
            if os.path.exists(src_file):
                dst_file = f"{temp_dir}/42NFT_{i}.svg"
                shutil.copy2(src_file, dst_file)
                file_count += 1
                print(f"   ✓ Prepared 42NFT_{i}.svg")
        
        print(f"📊 Ready to upload {file_count} files")
        
        # Upload to Pinata
        ipfs_hash = uploader.upload_folder(temp_dir, "42-nft-art-collection")
        
        if ipfs_hash:
            print(f"🎉 Upload successful!")
            print(f"📋 IPFS Hash: {ipfs_hash}")
            
            # Save summary
            summary = f"""42 NFT Art Collection - Pinata Upload Summary
==============================================

Upload Date: {json.dumps(str(os.popen('date').read().strip()))}
IPFS Hash: {ipfs_hash}
Files Uploaded: {file_count} SVG files

Gateway URLs:
- Pinata: https://gateway.pinata.cloud/ipfs/{ipfs_hash}
- IPFS.io: https://ipfs.io/ipfs/{ipfs_hash}
- Cloudflare: https://cloudflare-ipfs.com/ipfs/{ipfs_hash}

Smart Contract Setup:
====================
After deploying your contract, call:
contract.setIPFSHash("{ipfs_hash}");

Individual File URLs (examples):
- 42NFT_1.svg: https://gateway.pinata.cloud/ipfs/{ipfs_hash}/42NFT_1.svg
- 42NFT_2.svg: https://gateway.pinata.cloud/ipfs/{ipfs_hash}/42NFT_2.svg
- etc...

Token Metadata URLs:
- Design ID 0 → 42NFT_1.svg
- Design ID 1 → 42NFT_2.svg
- ...
- Design ID 21 → 42NFT_22.svg
- Design ID 22 → Onchain bonusSVG
"""
            
            with open("pinata-upload-summary.txt", "w") as f:
                f.write(summary)
            
            print("📄 Summary saved to: pinata-upload-summary.txt")
            print("")
            print("🔧 Next Steps:")
            print("1. Deploy your smart contract")
            print(f"2. Call setIPFSHash(\"{ipfs_hash}\") on your deployed contract")
            print("3. Test a few token URLs to ensure they work")
            
        else:
            print("❌ Upload failed. Please check your API keys and try again.")

if __name__ == "__main__":
    main()
