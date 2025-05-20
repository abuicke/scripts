import hashlib
import os
import json
from datetime import datetime
import argparse

def calculate_file_hash(filepath):
    """Calculate SHA-256 hash of a file."""
    sha256_hash = hashlib.sha256()
    with open(filepath, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

def generate_hashes(folder_path):
    """Generate hashes for all files in a folder and its subfolders."""
    hashes = {}
    for root, _, files in os.walk(folder_path):
        for filename in files:
            # Skip desktop.ini files
            if filename.lower() == 'desktop.ini':
                continue

            filepath = os.path.join(root, filename)
            relative_path = os.path.relpath(filepath, folder_path)
            try:
                file_hash = calculate_file_hash(filepath)
                hashes[relative_path] = file_hash
            except (IOError, OSError) as e:
                print(f"Error processing {filepath}: {e}")
    return hashes

def save_hashes(hashes, folder_path, output_file):
    """Save hashes to a JSON file with metadata."""
    data = {
        "folder_path": folder_path,
        "timestamp": datetime.now().isoformat(),
        "hashes": hashes
    }
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=4)
    print(f"Hashes saved to {output_file}")

def verify_hashes(folder_path, hash_file):
    """Verify current folder contents against saved hashes."""
    # Load saved hashes
    with open(hash_file, 'r') as f:
        saved_data = json.load(f)
    
    saved_hashes = saved_data["hashes"]
    current_hashes = generate_hashes(folder_path)
    
    # Compare files
    unchanged = []
    changed = []
    missing = []
    new = []
    
    # Check for changed and missing files
    for filepath, saved_hash in saved_hashes.items():
        if filepath in current_hashes:
            if current_hashes[filepath] == saved_hash:
                unchanged.append(filepath)
            else:
                changed.append(filepath)
        else:
            missing.append(filepath)
    
    # Check for new files, excluding desktop.ini
    new = [f for f in current_hashes if f not in saved_hashes and os.path.basename(f).lower() != 'desktop.ini']
    
    # Print results
    print("\nVerification Results:")
    print(f"Original hash file created: {saved_data['timestamp']}")
    print(f"\nUnchanged files: {len(unchanged)}")
    
    if changed:
        print(f"\nChanged files ({len(changed)}):")
        for f in changed:
            print(f"  {f}")
    
    if missing:
        print(f"\nMissing files ({len(missing)}):")
        for f in missing:
            print(f"  {f}")
    
    if new:
        print(f"\nNew files ({len(new)}):")
        for f in new:
            print(f"  {f}")

def main():
    parser = argparse.ArgumentParser(description="File integrity checker")
    parser.add_argument('folder', help='Folder to check')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--generate', metavar='OUTPUT_FILE',
                      help='Generate new hash file')
    group.add_argument('--verify', metavar='HASH_FILE',
                      help='Verify against existing hash file')
    
    args = parser.parse_args()
    
    if not os.path.isdir(args.folder):
        print(f"Error: {args.folder} is not a valid directory")
        return
    
    if args.generate:
        hashes = generate_hashes(args.folder)
        save_hashes(hashes, args.folder, args.generate)
    else:
        verify_hashes(args.folder, args.verify)

if __name__ == "__main__":
    main()
