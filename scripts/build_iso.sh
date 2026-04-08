#!/usr/bin/env bash

set -euo pipefail

# Get the project root directory (one level up from this script)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Building Barbarous Core OSTree Container Image..."
# We use sudo here so the image is built into Root storage, making it accessible to the builder.
sudo podman build -t localhost/barbarous-core:latest -f "$PROJECT_ROOT/build/Containerfile" "$PROJECT_ROOT"

echo "==> Building Bootable Live ISO from Container..."
echo "Note: This generates a live bootable environment. It requires root privileges."
sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
  --network host \
  --security-opt label=type:unconfined_t \
  -v "$PROJECT_ROOT/build":/output \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  --rootfs xfs \
  localhost/barbarous-core:latest

echo "==> Done! Your custom offline-ready ISO is located in the build/ directory."

echo "==> Initializing ISO Branding (Replacing labels & volume ID)..."
sudo "$PROJECT_ROOT/scripts/brand_iso.sh"

echo "==> Build Process Finished Successfully."
