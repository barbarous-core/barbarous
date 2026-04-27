#!/bin/bash

# Configuration
INPUT_FILE="/home/mohamed/barbarous/docs/Barbarous_Dotfiles.md"
OUTPUT_DIR="/home/mohamed/barbarous/iso_assets/dotfiles"
TEMP_DIR="/home/mohamed/barbarous/scripts/dotfiles_tmp"

# Create necessary directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TEMP_DIR"

echo "--------------------------------------------------"
echo "Barbarous Dotfile Fetcher"
echo "Extracting repositories from: $INPUT_FILE"
echo "Target directory: $OUTPUT_DIR"
echo "--------------------------------------------------"

# Extract URLs specifically from Section 6 'Curated Inbox Repositories'
# 1. Find line number of Section 6
# 2. Extract following lines starting with '| **'
# 3. Capture URL inside (parentheses)
start_line=$(grep -n "## 6. Curated Inbox Repositories" "$INPUT_FILE" | cut -d: -f1)
repos=$(tail -n +$start_line "$INPUT_FILE" | grep -E "^\| \*\*" | sed -E 's/.*\[GitHub\]\((.*)\).*/\1/')

if [ -z "$repos" ]; then
    echo "Error: No repositories found in $INPUT_FILE"
    exit 1
fi

for url in $repos; do
    # Generate a clean name for the archive (e.g., Aetf-dotfiles)
    # 1. Strip https://github.com/
    # 2. Replace / with -
    # 3. Strip .git suffix
    repo_slug=$(echo "$url" | sed -E 's|https://github.com/||; s|/|-|g; s|\.git$||')
    
    echo ">> Fetching: $repo_slug..."
    
    # Define paths
    clone_path="$TEMP_DIR/$repo_slug"
    archive_name="${repo_slug}.tar.gz"
    
    # Shallow clone to save time/space
    git clone --depth 1 "$url" "$clone_path" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        # Create a compressed tarball
        # We use -C to change directory so the archive doesn't contain the full path
        tar -czf "$OUTPUT_DIR/$archive_name" -C "$TEMP_DIR" "$repo_slug"
        
        if [ $? -eq 0 ]; then
            echo "   [SUCCESS] Compressed to $archive_name"
        else
            echo "   [ERROR] Compression failed for $repo_slug"
        fi
        
        # Remove the cloned source
        rm -rf "$clone_path"
    else
        echo "   [ERROR] Failed to clone $url"
    fi
done

# Cleanup the temp directory
rm -rf "$TEMP_DIR"

echo "--------------------------------------------------"
echo "Finished processing all repositories."
echo "Total files in $OUTPUT_DIR: $(ls -1 "$OUTPUT_DIR" | wc -l)"
echo "--------------------------------------------------"
