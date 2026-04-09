#!/usr/bin/env bash
# Barbarous Core Binary Fetcher
# Downloads the latest x86_64 binaries from GitHub releases.

BIN_DIR="/home/mohamed/barbarous/iso_assets/bin"
mkdir -p "$BIN_DIR"

# Repo list: "Owner/RepoName"
REPOS=(
    "eza-community/eza"
    "sharkdp/bat"
    "aristocratos/btop"
    "BurntSushi/ripgrep"
    "starship/starship"
    "neovim/neovim"
    "cli/cli"
    "jesseduffield/lazygit"
    "fastfetch-cli/fastfetch"
    "ajeetdsouza/zoxide"
    "sharkdp/fd"
    "junegunn/fzf"
    "bootandy/dust"
    "zellij-org/zellij"
    "mikefarah/yq"
    "Duncaen/yazi"
    "Tebasul/jp2a"
)

echo "==> Fetching latest binaries for ${#REPOS[@]} tools..."

for repo in "${REPOS[@]}"; do
    echo "  -> Processing $repo..."
    
    # Get latest release info from GitHub API
    RELEASE_DATA=$(curl -s "https://api.github.com/repos/$repo/releases/latest")
    
    # Find the x86_64 linux asset URL (trying typical patterns)
    ASSET_URL=$(echo "$RELEASE_DATA" | grep -oP "https://github.com/[^\"]+x86_64[^\"]+linux[^\"]+\.(tar.gz|zip|xz|tar.xz)" | head -n 1)
    
    if [ -z "$ASSET_URL" ]; then
        # Fallback search if 'linux' wasn't in the name but x86_64 was
        ASSET_URL=$(echo "$RELEASE_DATA" | grep -oP "https://github.com/[^\"]+x86_64[^\"]+\.(tar.gz|zip|xz|tar.xz)" | head -n 1)
    fi

    if [ -n "$ASSET_URL" ]; then
        FILENAME=$(basename "$ASSET_URL")
        echo "     Downloading $FILENAME..."
        curl -L -o "/tmp/$FILENAME" "$ASSET_URL"
        
        # Extract based on extension
        echo "     Extracting..."
        mkdir -p "/tmp/extract_$repo"
        if [[ "$FILENAME" == *.zip ]]; then
            unzip -q "/tmp/$FILENAME" -d "/tmp/extract_$repo"
        else
            tar -xf "/tmp/$FILENAME" -C "/tmp/extract_$repo"
        fi
        
        # Find the binary in the extraction dir (looking for an executable file)
        # We try to find a file that matches the repo name or is a known binary
        BIN_NAME=$(basename "$repo")
        if [[ "$BIN_NAME" == "cli" ]]; then BIN_NAME="gh"; fi
        if [[ "$BIN_NAME" == "ripgrep" ]]; then BIN_NAME="rg"; fi
        
        FOUND_BIN=$(find "/tmp/extract_$repo" -type f -executable -name "$BIN_NAME" | head -n 1)
        
        if [ -n "$FOUND_BIN" ]; then
            cp "$FOUND_BIN" "$BIN_DIR/"
            chmod +x "$BIN_DIR/$(basename "$FOUND_BIN")"
            echo "     ✅ Saved to $BIN_DIR/$(basename "$FOUND_BIN")"
        else
            echo "     ⚠️  Warning: Binary '$BIN_NAME' not found in archive. Manual check needed."
        fi
        
        # Cleanup
        rm -rf "/tmp/extract_$repo" "/tmp/$FILENAME"
    else
        echo "     ❌ Error: Could not find suitable x86_64 linux asset for $repo."
    fi
done

echo "==> Done!"
