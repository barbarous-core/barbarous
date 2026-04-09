#!/usr/bin/env bash

# Barbarous Core: Unified Asset Injector & Brander
# This script securely embeds the Ignition configuration, sets correct boot flags,
# and performs a clean ISO remaster to inject the offline RPMs and binaries.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO_PATH="$PROJECT_ROOT/build/bootiso/install.iso"
ASSETS_DIR="$PROJECT_ROOT/iso_assets"

if [ ! -f "$ISO_PATH" ]; then
    echo "❌ Error: ISO not found at $ISO_PATH"
    exit 1
fi

echo "==> Step 1: CoreOS Installer Customization (Ignition & Boot Args)"
# We use the official tool FIRST so it doesn't fail on checksum/format mismatches
if [ -f "$ASSETS_DIR/barbarous.ign" ]; then
    sudo coreos-installer iso customize \
        --live-ignition "$ASSETS_DIR/barbarous.ign" \
        --live-karg-append="systemd.unit=multi-user.target" \
        --live-karg-append="coreos.autologin=tty1" \
        --live-karg-append="enforcing=0" \
        "$ISO_PATH"
else
    echo "⚠️ Warning: barbarous.ign not found. Skipping ignition embed."
fi

echo "==> Step 2: Extracting and Branding Boot Menu..."
# We extract the GRUB menu just to change the visual titles.
# We do NOT touch the linux arguments here, coreos-installer handled them!
ISO_TMP=$(mktemp -d)
sudo xorriso -osirrox on -indev "$ISO_PATH" -extract /EFI/fedora/grub.cfg "$ISO_TMP/grub.cfg" >/dev/null 2>&1 || true
sudo xorriso -osirrox on -indev "$ISO_PATH" -extract /isolinux/isolinux.cfg "$ISO_TMP/isolinux.cfg" >/dev/null 2>&1 || true

if [ -f "$ISO_TMP/grub.cfg" ]; then
    sudo sed -i "s/Fedora CoreOS/Barbarous Core/g" "$ISO_TMP/grub.cfg"
fi
if [ -f "$ISO_TMP/isolinux.cfg" ]; then
    sudo sed -i "s/Fedora CoreOS/Barbarous Core/g" "$ISO_TMP/isolinux.cfg"
fi

echo "==> Step 3: Injecting Assets and Boot Menu into ISO..."
# We append a single session to add our files without breaking the isohybrid structure
XORRISO_ARGS=(
    sudo xorriso -dev "$ISO_PATH"
    -boot_image any keep
    -map "$ASSETS_DIR" "/barbarous-assets"
)

if [ -f "$ISO_TMP/grub.cfg" ]; then
    XORRISO_ARGS+=("-map" "$ISO_TMP/grub.cfg" "/EFI/fedora/grub.cfg")
fi
if [ -f "$ISO_TMP/isolinux.cfg" ]; then
    XORRISO_ARGS+=("-map" "$ISO_TMP/isolinux.cfg" "/isolinux/isolinux.cfg")
fi

"${XORRISO_ARGS[@]}" -commit >/dev/null

sudo rm -rf "$ISO_TMP"
echo "✅ Barbarous ISO successfully generated!"
