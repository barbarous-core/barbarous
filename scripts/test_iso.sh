#!/usr/bin/env bash

# Barbarous Core: VM Testing Script
# This scripts boots the generated ISO in a QEMU virtual machine.

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO_PATH="$PROJECT_ROOT/build/bootiso/install.iso"

if [ ! -f "$ISO_PATH" ]; then
    echo "❌ Error: ISO not found at $ISO_PATH"
    echo "Please run ./scripts/build_iso.sh first."
    exit 1
fi

echo "🚀 Booting Barbarous Core Test VM..."
echo "Note: If the installer starts, you can test the 'Live' environment or complete the installation to a virtual disk."

qemu-system-x86_64 \
  -m 4G \
  -enable-kvm \
  -cpu host \
  -cdrom "$ISO_PATH" \
  -net nic,model=virtio -net user \
  -vga virtio \
  -display gtk
