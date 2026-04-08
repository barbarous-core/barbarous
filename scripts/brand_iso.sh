#!/usr/bin/env bash

# Barbarous Core: ISO Branding Script
# This script post-processes the generated ISO to replace Fedora branding
# with Barbarous branding in the boot menu and volume ID.

set -euo pipefail

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO_PATH="$PROJECT_ROOT/build/bootiso/install.iso"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

OLD_LABEL="Fedora-S-dvd-x86_64-43"
NEW_LABEL="Barbarous-Core-Live"

# Target config files in the ISO
GRUB_EFI="/EFI/BOOT/grub.cfg"
GRUB_BIOS="/boot/grub2/grub.cfg"

if [ ! -f "$ISO_PATH" ]; then
    echo "❌ Error: ISO not found at $ISO_PATH"
    exit 1
fi

echo "==> Branding ISO: $ISO_PATH"

for CFG in "$GRUB_EFI" "$GRUB_BIOS"; do
    echo "  -> Processing $CFG..."
    
    # Extract
    xorriso -indev "$ISO_PATH" -osirrox on -extract "$CFG" "$TMP_DIR/tmp.cfg"
    
    # Modify
    # 1. Replace visible menu entries
    sed -i "s/Install Fedora Linux 43/Barbarous Linux 43 (Live)/g" "$TMP_DIR/tmp.cfg"
    sed -i "s/Test this media & install Fedora Linux 43/Test this media \& Barbarous Linux 43 (Live)/g" "$TMP_DIR/tmp.cfg"
    sed -i "s/Rescue a Fedora Linux system/Rescue a Barbarous Linux system/g" "$TMP_DIR/tmp.cfg"
    sed -i "s/Fedora Linux 43 in basic graphics mode/Barbarous Linux 43 in basic graphics mode/g" "$TMP_DIR/tmp.cfg"
    
    # 2. Replace volume label references (critical for boot)
    sed -i "s/$OLD_LABEL/$NEW_LABEL/g" "$TMP_DIR/tmp.cfg"
    
    # Replace back in ISO
    # We use -boot_image any keep to preserve the bootloader/hybrid structure
    xorriso -dev "$ISO_PATH" -boot_image any keep -map "$TMP_DIR/tmp.cfg" "$CFG" -commit
done

# Finally, change the Volume ID of the ISO itself
echo "  -> Changing Volume ID to $NEW_LABEL..."
xorriso -dev "$ISO_PATH" -boot_image any keep -volid "$NEW_LABEL" -commit

echo "✅ ISO Branding Complete: Barbarous Core (Live)"
