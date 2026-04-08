#!/usr/bin/env bash

set -euo pipefail

# Get the project root directory (one level up from this script)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Building Barbarous Core OSTree Container Image..."
# We use sudo here so the image is built into Root storage, making it accessible to the builder.
sudo podman build -t localhost/barbarous-core:latest -f "$PROJECT_ROOT/build/Containerfile" "$PROJECT_ROOT"

echo "==> Building Anaconda Bootable ISO from Container..."
echo "Note: This uses the official bootc-image-builder utility. It requires root privileges."
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
  --type anaconda-iso \
  --rootfs xfs \
  --anaconda-ks /output/anaconda.ks \
  localhost/barbarous-core:latest

echo "==> Done! Your custom offline-ready ISO is located in the build/ directory."
