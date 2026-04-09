#!/usr/bin/env bash

set -eo pipefail

BIN_DIR="/home/mohamed/barbarous/iso_assets/bin"
mkdir -p "$BIN_DIR"
cd "$BIN_DIR"

echo "==> Downloading standalone binaries into $BIN_DIR..."

get_latest_github_release() {
    local repo="$1"
    local pattern="$2"
    local asset_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep -m 1 "browser_download_url.*$pattern" | cut -d '"' -f 4)
    if [ -z "$asset_url" ]; then
        # fallback if latest is a prerelease and doesn't show up in /latest
        asset_url=$(curl -s "https://api.github.com/repos/$repo/releases" | grep -m 1 "browser_download_url.*$pattern" | cut -d '"' -f 4)
    fi
    echo "$asset_url"
}

download_and_extract() {
    local url="$1"
    local bin_name="$2"
    local inside_archive_pattern="$3"

    if [ -f "$bin_name" ]; then
        echo "  [SKIP] $bin_name already exists."
        return
    fi
    if [ -z "$url" ]; then
        echo "  [FAIL] URL is empty for $bin_name. Skipping."
        return
    fi
    
    echo "  [DL] Fetching $bin_name..."
    
    if [[ "$url" == *.tar.gz ]]; then
        curl -sL "$url" | tar xz --wildcards "$inside_archive_pattern" -O > "$bin_name"
        chmod +x "$bin_name"
    elif [[ "$url" == *.zip ]]; then
        local tmpfile=$(mktemp "${bin_name}_XXXX.zip")
        curl -sL "$url" -o "$tmpfile"
        unzip -p "$tmpfile" "*$inside_archive_pattern" > "$bin_name"
        chmod +x "$bin_name"
        rm -f "$tmpfile"
    else
        # Direct binary file download (or raw script)
        curl -sL "$url" -o "$bin_name"
        chmod +x "$bin_name"
    fi
}

echo "1. GitHub Go/Rust/C Binaries..."

# fzf
url=$(get_latest_github_release "junegunn/fzf" "linux_amd64.tar.gz")
download_and_extract "$url" "fzf" "fzf"

# lsd
url=$(get_latest_github_release "lsd-rs/lsd" "x86_64-unknown-linux-gnu.tar.gz")
download_and_extract "$url" "lsd" "*/lsd"

# yazi
url=$(get_latest_github_release "sxyazi/yazi" "x86_64-unknown-linux-gnu.zip")
download_and_extract "$url" "yazi" "yazi"

# gh
url=$(get_latest_github_release "cli/cli" "linux_amd64.tar.gz")
download_and_extract "$url" "gh" "*/bin/gh"

# yq (mikefarah/yq)
url="https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"
download_and_extract "$url" "yq" ""

# bottom
url=$(get_latest_github_release "ClementTsang/bottom" "x86_64-unknown-linux-gnu.tar.gz")
download_and_extract "$url" "bottom" "*/btm" 
if [ -f "bottom" ] && [ ! -s "bottom" ]; then
    # if our wildcard didn't work, might just be 'btm' at root
    rm "bottom"
    download_and_extract "$url" "bottom" "btm"
fi
[ -f "bottom" ] && mv bottom btm && echo "  [RENAMED] bottom to btm" || true

# chezmoi
url=$(get_latest_github_release "twpayne/chezmoi" "linux_amd64.tar.gz")
download_and_extract "$url" "chezmoi" "chezmoi"

# croc
url=$(get_latest_github_release "schollz/croc" "Linux-64bit.tar.gz")
download_and_extract "$url" "croc" "croc"

# lazygit
url=$(get_latest_github_release "jesseduffield/lazygit" "Linux_x86_64.tar.gz")
download_and_extract "$url" "lazygit" "lazygit"

# fastfetch
url=$(get_latest_github_release "fastfetch-cli/fastfetch" "linux-amd64.tar.gz")
download_and_extract "$url" "fastfetch" "*/usr/bin/fastfetch"

# broot (direct download easier)
download_and_extract "https://dystroy.org/broot/download/x86_64-linux/broot" "broot" ""

echo "2. Raw Shell Scripts..."

# neofetch
download_and_extract "https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch" "neofetch" ""

# pipes.sh
download_and_extract "https://raw.githubusercontent.com/pipeseroni/pipes.sh/master/pipes.sh" "pipes.sh" ""

echo "✅ Missing portable binaries setup complete."
