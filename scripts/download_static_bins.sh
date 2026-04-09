#!/usr/bin/env bash

# Barbarous Core: Static Binary Downloader
# Uses the GitHub "releases/latest" redirect trick (no API key, no rate limits)
# to resolve the latest version tag and build direct asset URLs.

set -eo pipefail

BIN_DIR="/home/mohamed/barbarous/iso_assets/bin"
mkdir -p "$BIN_DIR"
cd "$BIN_DIR"

echo "==> Downloading standalone binaries into $BIN_DIR..."

# ── Helpers ────────────────────────────────────────────────────────────────────

# Resolve the latest version tag for a GitHub repo (no API required)
latest_tag() {
    curl -sL -w "%{url_effective}" -o /dev/null \
        "https://github.com/$1/releases/latest" | awk -F'/' '{print $NF}'
}

# Download and extract a binary from an archive or direct URL.
# Usage: fetch BIN_NAME URL [PATTERN_IN_ARCHIVE]
fetch() {
    local bin_name="$1"
    local url="$2"
    local pattern="${3:-$bin_name}"   # default: look for a file named $bin_name

    if [ -f "$bin_name" ] && [ -s "$bin_name" ]; then
        echo "  [SKIP] $bin_name"
        return
    fi
    # Remove empty/partial file from a previous failed attempt
    rm -f "$bin_name"

    if [ -z "$url" ]; then
        echo "  [FAIL] Empty URL → $bin_name"
        return
    fi

    echo "  [DL]   $bin_name  ← $url"

    if [[ "$url" == *.tar.gz || "$url" == *.tgz ]]; then
        local tmp; tmp=$(mktemp /tmp/bbl_XXXX.tar.gz)
        curl -sL "$url" -o "$tmp"
        # Try exact pattern, then nested, then the bin name itself
        tar xzf "$tmp" --wildcards "$pattern"    -O > "$bin_name" 2>/dev/null || \
        tar xzf "$tmp" --wildcards "*/$pattern"  -O > "$bin_name" 2>/dev/null || \
        tar xzf "$tmp" --wildcards "*/$bin_name" -O > "$bin_name" 2>/dev/null || \
        { echo "  [FAIL] Could not extract $bin_name from archive"; rm -f "$tmp" "$bin_name"; return; }
        rm -f "$tmp"
    elif [[ "$url" == *.zip ]]; then
        local tmp; tmp=$(mktemp /tmp/bbl_XXXX.zip)
        curl -sL "$url" -o "$tmp"
        unzip -p "$tmp" "*$pattern"    > "$bin_name" 2>/dev/null || \
        unzip -p "$tmp" "*/$bin_name"  > "$bin_name" 2>/dev/null || \
        { echo "  [FAIL] Could not extract $bin_name from zip"; rm -f "$tmp" "$bin_name"; return; }
        rm -f "$tmp"
    else
        # Direct binary / shell script
        curl -sL "$url" -o "$bin_name"
    fi

    [ -s "$bin_name" ] && chmod +x "$bin_name" || { echo "  [FAIL] Empty result → $bin_name"; rm -f "$bin_name"; }
}

# ── File Management & Navigation ───────────────────────────────────────────────
echo ""
echo "── File Management ──────────────────────────────────────────────────────"

V=$(latest_tag "eza-community/eza")
fetch eza "https://github.com/eza-community/eza/releases/download/$V/eza_x86_64-unknown-linux-gnu.tar.gz" "eza"

V=$(latest_tag "lsd-rs/lsd")
fetch lsd "https://github.com/lsd-rs/lsd/releases/download/$V/lsd-${V}-x86_64-unknown-linux-gnu.tar.gz" "lsd"

V=$(latest_tag "sxyazi/yazi")
fetch yazi "https://github.com/sxyazi/yazi/releases/download/$V/yazi-x86_64-unknown-linux-gnu.zip" "yazi"

V=$(latest_tag "yorukot/superfile")
# superfile binary is named 'spf' inside ./dist/.../spf
if [ ! -f "spf" ] || [ ! -s "spf" ]; then
  rm -f spf
  tmp=$(mktemp /tmp/spf_XXXX.tar.gz)
  curl -sL "https://github.com/yorukot/superfile/releases/download/$V/superfile-linux-${V}-amd64.tar.gz" -o "$tmp"
  tar xzf "$tmp" --wildcards "*/spf" -O > spf 2>/dev/null && chmod +x spf && echo "  [OK]   spf (superfile)" || echo "  [FAIL] spf"
  rm -f "$tmp"
else
  echo "  [SKIP] spf (superfile)"
fi

V=$(latest_tag "ajeetdsouza/zoxide")
fetch zoxide "https://github.com/ajeetdsouza/zoxide/releases/download/$V/zoxide-${V}-x86_64-unknown-linux-musl.tar.gz" "zoxide"

V=$(latest_tag "sharkdp/fd")
fetch fd "https://github.com/sharkdp/fd/releases/download/$V/fd-${V}-x86_64-unknown-linux-gnu.tar.gz" "fd"

V=$(latest_tag "junegunn/fzf")
fetch fzf "https://github.com/junegunn/fzf/releases/download/$V/fzf-${V}-linux_amd64.tar.gz" "fzf"

V=$(latest_tag "bootandy/dust")
fetch dust "https://github.com/bootandy/dust/releases/download/$V/dust-${V}-x86_64-unknown-linux-gnu.tar.gz" "dust"

V=$(latest_tag "Canop/broot")
fetch broot "https://dystroy.org/broot/download/x86_64-linux/broot"

# ── Text & Search ──────────────────────────────────────────────────────────────
echo ""
echo "── Text & Search ────────────────────────────────────────────────────────"

V=$(latest_tag "sharkdp/bat")
fetch bat "https://github.com/sharkdp/bat/releases/download/$V/bat-${V}-x86_64-unknown-linux-gnu.tar.gz" "bat"

V=$(latest_tag "BurntSushi/ripgrep")
fetch rg "https://github.com/BurntSushi/ripgrep/releases/download/$V/ripgrep-${V}-x86_64-unknown-linux-musl.tar.gz" "rg"

# yq — mikefarah project uses predictable asset names
fetch yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"

V=$(latest_tag "pemistahl/grex")
fetch grex "https://github.com/pemistahl/grex/releases/download/$V/grex-${V}-x86_64-unknown-linux-musl.tar.gz" "grex"

V=$(latest_tag "chmln/sd")
fetch sd "https://github.com/chmln/sd/releases/download/$V/sd-${V}-x86_64-unknown-linux-musl.tar.gz" "sd"

# ── System Management & Monitoring ────────────────────────────────────────────
echo ""
echo "── System Monitoring ────────────────────────────────────────────────────"

V=$(latest_tag "aristocratos/btop")
# btop is bzip2 (.tbz), extract bin/btop from nested btop/bin/btop
if [ ! -f "btop" ] || [ ! -s "btop" ]; then
  rm -f btop
  tmp=$(mktemp /tmp/btop_XXXX.tbz)
  curl -sL "https://github.com/aristocratos/btop/releases/download/$V/btop-x86_64-unknown-linux-musl.tbz" -o "$tmp"
  tar xjf "$tmp" --wildcards "*/bin/btop" -O > btop 2>/dev/null && chmod +x btop && echo "  [OK]   btop" || echo "  [FAIL] btop"
  rm -f "$tmp"
else
  echo "  [SKIP] btop"
fi

V=$(latest_tag "ClementTsang/bottom")
fetch btm "https://github.com/ClementTsang/bottom/releases/download/$V/bottom_x86_64-unknown-linux-gnu.tar.gz" "btm"

V=$(latest_tag "twpayne/chezmoi")
fetch chezmoi "https://github.com/twpayne/chezmoi/releases/download/$V/chezmoi-linux-amd64.tar.gz" "chezmoi"

# ── Shell, Terminal & Environment ─────────────────────────────────────────────
echo ""
echo "── Shell & Terminal ─────────────────────────────────────────────────────"

V=$(latest_tag "zellij-org/zellij")
fetch zellij "https://github.com/zellij-org/zellij/releases/download/$V/zellij-x86_64-unknown-linux-musl.tar.gz" "zellij"

V=$(latest_tag "starship/starship")
fetch starship "https://github.com/starship/starship/releases/download/$V/starship-x86_64-unknown-linux-musl.tar.gz" "starship"

V=$(latest_tag "atuinsh/atuin")
fetch atuin "https://github.com/atuinsh/atuin/releases/download/$V/atuin-x86_64-unknown-linux-gnu.tar.gz" "atuin"

V=$(latest_tag "denisidoro/navi")
fetch navi "https://github.com/denisidoro/navi/releases/download/$V/navi-${V}-x86_64-unknown-linux-musl.tar.gz" "navi"

V=$(latest_tag "tealdeer-rs/tealdeer")
fetch tealdeer "https://github.com/tealdeer-rs/tealdeer/releases/download/$V/tealdeer-linux-x86_64-musl"

V=$(latest_tag "tsl0922/ttyd")
fetch ttyd "https://github.com/tsl0922/ttyd/releases/download/$V/ttyd.x86_64"

# ── Networking ────────────────────────────────────────────────────────────────
echo ""
echo "── Networking ───────────────────────────────────────────────────────────"

V=$(latest_tag "pythops/bluetui")
# bluetui ships as a direct static binary (musl), not an archive
fetch bluetui "https://github.com/pythops/bluetui/releases/download/$V/bluetui-x86_64-linux-musl"

V=$(latest_tag "schollz/croc")
fetch croc "https://github.com/schollz/croc/releases/download/$V/croc_${V}_Linux-64bit.tar.gz" "croc"

# axel has no reliable static release binary — skip (install via rpm-ostree on target)
echo "  [SKIP] axel — no static binary available, install via rpm-ostree"

# ── Development & Git ─────────────────────────────────────────────────────────
echo ""
echo "── Development & Git ────────────────────────────────────────────────────"

# neovim
fetch nvim "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" "nvim-linux-x86_64/bin/nvim"

V=$(latest_tag "cli/cli")
fetch gh "https://github.com/cli/cli/releases/download/$V/gh_${V#v}_linux_amd64.tar.gz" "gh_${V#v}_linux_amd64/bin/gh"

V=$(latest_tag "jesseduffield/lazygit")
fetch lazygit "https://github.com/jesseduffield/lazygit/releases/download/$V/lazygit_${V#v}_Linux_x86_64.tar.gz" "lazygit"

# ── Media & Fun ───────────────────────────────────────────────────────────────
echo ""
echo "── Media & Fun ──────────────────────────────────────────────────────────"

V=$(latest_tag "fastfetch-cli/fastfetch")
fetch fastfetch "https://github.com/fastfetch-cli/fastfetch/releases/download/$V/fastfetch-linux-amd64.tar.gz" "usr/bin/fastfetch"

# neofetch — raw shell script
fetch neofetch "https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch"

# pipes.sh — raw shell script
fetch pipes.sh "https://raw.githubusercontent.com/pipeseroni/pipes.sh/master/pipes.sh"

# asciinema
V=$(latest_tag "asciinema/asciinema")
# asciinema ships as a direct static musl binary
fetch asciinema "https://github.com/asciinema/asciinema/releases/download/$V/asciinema-x86_64-unknown-linux-musl"

# pastel
V=$(latest_tag "sharkdp/pastel")
fetch pastel "https://github.com/sharkdp/pastel/releases/download/$V/pastel-${V}-x86_64-unknown-linux-musl.tar.gz" "pastel"

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "── Final bin directory ──────────────────────────────────────────────────"
ls -lh "$BIN_DIR" | awk '{printf "  %-20s %s\n", $9, $5}'
echo ""
COUNT=$(ls "$BIN_DIR" | wc -l)
echo "✅ Done! $COUNT binaries in $BIN_DIR"
