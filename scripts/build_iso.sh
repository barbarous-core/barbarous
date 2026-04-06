#!/usr/bin/env bash

set -euo pipefail

echo "==> Building Barbarous Core OSTree Container Image..."
podman build -t localhost/barbarous-core:latest -f build/Containerfile .

echo "==> Building Anaconda Bootable ISO from Container..."
echo "Note: This uses the official bootc-image-builder utility. It requires root privileges."
sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
  --security-opt label=type:unconfined_t \
  -v $(pwd)/build:/output \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type anaconda-iso \
  --local \
  localhost/barbarous-core:latest

echo "==> Done! Your custom offline-ready ISO is located in the build/ directory."
