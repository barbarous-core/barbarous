#!/usr/bin/env bash

# Barbarous Core: Unified Asset Injector & Brander
# ─────────────────────────────────────────────────
# Steps:
#   0. Pre-flight checks  (ISO, Ignition, real binaries)
#   1. Auto-download any missing static binaries
#   2. CoreOS Installer   (embed Ignition + boot args)
#   3. Boot menu branding (GRUB & isolinux titles)
#   4. ISO asset injection (xorriso session append)

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO_PATH="$PROJECT_ROOT/build/bootiso/install.iso"
ASSETS_DIR="$PROJECT_ROOT/iso_assets"
BIN_DIR="$ASSETS_DIR/bin"
IGN_FILE="$ASSETS_DIR/barbarous.ign"
DOWNLOAD_SCRIPT="$PROJECT_ROOT/scripts/download_static_bins.sh"

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

step()  { echo -e "\n${CYAN}${BOLD}==> $*${NC}"; }
ok()    { echo -e "  ${GREEN}✔${NC}  $*"; }
warn()  { echo -e "  ${YELLOW}⚠${NC}  $*"; }
fail()  { echo -e "  ${RED}✘${NC}  $*"; }

# ─── Step 0: Pre-flight checks ────────────────────────────────────────────────
step "Step 0: Pre-flight checks"

if [ ! -f "$ISO_PATH" ]; then
    fail "ISO not found at $ISO_PATH"
    exit 1
fi
ok "ISO found: $ISO_PATH ($(du -sh "$ISO_PATH" | cut -f1))"

if [ ! -f "$IGN_FILE" ]; then
    warn "barbarous.ign not found at $IGN_FILE — Ignition will be skipped."
    IGN_MISSING=1
else
    ok "Ignition config: $IGN_FILE"
    IGN_MISSING=0
fi

# Sync logo and fastfetch config from source assets
LOGO_SRC="$PROJECT_ROOT/assets/images/logo/logo_main.txt"
if [ -f "$LOGO_SRC" ]; then
    cp "$LOGO_SRC" "$ASSETS_DIR/barbarous_logo.txt"
    ok "Logo synced: barbarous_logo.txt"
else
    warn "Logo not found at $LOGO_SRC"
fi

# Sync dotfiles structure validation
DOTFILES_DIR="$ASSETS_DIR/dotfiles"
FFCONFIG_SRC="$DOTFILES_DIR/fastfetch/.config/fastfetch/config.jsonc"
ZSHCONFIG_SRC="$DOTFILES_DIR/zsh/.zshrc"

if [ -f "$FFCONFIG_SRC" ]; then
    ok "Fastfetch: Modular config detected (Stow-ready)"
else
    warn "Fastfetch: Modular config NOT found at $FFCONFIG_SRC"
fi

if [ -f "$ZSHCONFIG_SRC" ]; then
    ok "Zsh: Modular config detected (Stow-ready)"
else
    warn "Zsh: Modular config NOT found at $ZSHCONFIG_SRC"
fi

# Count real binaries (>100KB = not a mock script)
REAL_BIN_COUNT=0
MOCK_BINS=()
if [ -d "$BIN_DIR" ]; then
    for f in "$BIN_DIR"/*; do
        [ -f "$f" ] || continue
        sz=$(wc -c < "$f")
        if [ "$sz" -gt 102400 ]; then
            REAL_BIN_COUNT=$((REAL_BIN_COUNT + 1))
        else
            MOCK_BINS+=("$(basename "$f")")
        fi
    done
fi
ok "Real binaries in $BIN_DIR: $REAL_BIN_COUNT"
if [ ${#MOCK_BINS[@]} -gt 0 ]; then
    warn "Tiny files detected (may be mock scripts): ${MOCK_BINS[*]}"
fi

# ─── Step 1: Auto-download missing binaries ───────────────────────────────────
step "Step 1: Ensuring all static binaries are downloaded"

EXPECTED_MIN=30   # We expect at least 30 real binaries

if [ "$REAL_BIN_COUNT" -lt "$EXPECTED_MIN" ]; then
    warn "Only $REAL_BIN_COUNT real binaries found (expected ≥ $EXPECTED_MIN)."
    if [ -x "$DOWNLOAD_SCRIPT" ]; then
        echo "  Running download_static_bins.sh..."
        bash "$DOWNLOAD_SCRIPT"
    else
        warn "Download script not found or not executable: $DOWNLOAD_SCRIPT"
        warn "Run it manually: bash scripts/download_static_bins.sh"
    fi
else
    ok "All $REAL_BIN_COUNT binaries present — skipping download."
fi

# ─── Step 2: CoreOS Installer (Ignition + Boot Args) ─────────────────────────
step "Step 2: CoreOS Installer — embedding Ignition & boot args"

# Automatically compile 99-barbarous.sh into barbarous.ign if it exists!
PROFILE_SCRIPT="$ASSETS_DIR/99-barbarous.sh"
if [ -f "$PROFILE_SCRIPT" ] && [ "$IGN_MISSING" -eq 0 ]; then
    echo "  -> Compiling 99-barbarous.sh into Ignition config..."
    B64_SCRIPT=$(base64 -w 0 "$PROFILE_SCRIPT")
    jq --arg base64 "data:text/plain;base64,$B64_SCRIPT" \
       '(.storage.files[] | select(.path == "/etc/profile.d/99-barbarous.sh") | .contents.source) = $base64' \
       "$IGN_FILE" > "${IGN_FILE}.tmp" && sudo mv "${IGN_FILE}.tmp" "$IGN_FILE"
fi

if [ "$IGN_MISSING" -eq 0 ]; then
    sudo coreos-installer iso customize \
        --live-ignition "$IGN_FILE" \
        --live-karg-append="systemd.unit=multi-user.target" \
        --live-karg-append="coreos.autologin=tty1" \
        --live-karg-append="enforcing=0" \
        "$ISO_PATH"
    ok "Ignition embedded + boot args applied."
else
    warn "Skipping Ignition embed (no .ign file found)."
fi

# ─── Step 3: Boot menu branding ───────────────────────────────────────────────
step "Step 3: Branding boot menu (GRUB & isolinux)"

ISO_TMP=$(mktemp -d)
trap "sudo rm -rf '$ISO_TMP'" EXIT

sudo xorriso -osirrox on -indev "$ISO_PATH" \
    -extract /EFI/fedora/grub.cfg     "$ISO_TMP/grub.cfg"     >/dev/null 2>&1 || true
sudo xorriso -osirrox on -indev "$ISO_PATH" \
    -extract /isolinux/isolinux.cfg   "$ISO_TMP/isolinux.cfg"  >/dev/null 2>&1 || true

BRANDED=0
if [ -f "$ISO_TMP/grub.cfg" ]; then
    sudo sed -i "s/Fedora CoreOS/Barbarous Core/g" "$ISO_TMP/grub.cfg"
    ok "Branded: grub.cfg"
    BRANDED=$((BRANDED + 1))
fi
if [ -f "$ISO_TMP/isolinux.cfg" ]; then
    sudo sed -i "s/Fedora CoreOS/Barbarous Core/g" "$ISO_TMP/isolinux.cfg"
    ok "Branded: isolinux.cfg"
    BRANDED=$((BRANDED + 1))
fi
[ "$BRANDED" -eq 0 ] && warn "No boot config files found to brand."

# ─── Step 4: Inject all assets into ISO ───────────────────────────────────────
step "Step 4: Injecting assets into ISO (xorriso)"

echo "  Mapping:"
echo "    $ASSETS_DIR  →  /barbarous-assets"
[ -f "$ISO_TMP/grub.cfg" ]     && echo "    grub.cfg      →  /EFI/fedora/grub.cfg"
[ -f "$ISO_TMP/isolinux.cfg" ] && echo "    isolinux.cfg  →  /isolinux/isolinux.cfg"
echo ""

XORRISO_ARGS=(
    sudo xorriso -dev "$ISO_PATH"
    -boot_image any keep
    -map "$ASSETS_DIR" "/barbarous-assets"
)

[ -f "$ISO_TMP/grub.cfg" ]     && XORRISO_ARGS+=("-map" "$ISO_TMP/grub.cfg"     "/EFI/fedora/grub.cfg")
[ -f "$ISO_TMP/isolinux.cfg" ] && XORRISO_ARGS+=("-map" "$ISO_TMP/isolinux.cfg" "/isolinux/isolinux.cfg")

"${XORRISO_ARGS[@]}" -commit >/dev/null

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}✅ Barbarous ISO successfully generated!${NC}"
echo ""
echo "  ISO path : $ISO_PATH"
echo "  ISO size : $(du -sh "$ISO_PATH" | cut -f1)"
echo "  Binaries : $REAL_BIN_COUNT injected into /barbarous-assets/bin/"
echo ""
echo "  On live boot, run:  bash /run/media/.../barbarous-assets/setup.sh"
echo "  or:                 ls /barbarous-assets/bin/"
