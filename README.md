# Barbarous

Barbarous is a custom Linux distribution based on Fedora CoreOS.

## Project Structure

This project follows a standard layout for customizing immutable Linux distributions like Fedora CoreOS:

* **`config/butane/`**: Stores your Butane (`.bu`) configuration files which are transpiled to Ignition configs for first-boot provisioning.
* **`rootfs/`**: Contains files and directories that will be placed directly into the file system (e.g., custom configuration files in `rootfs/etc/` or static binaries in `rootfs/usr/local/bin/`).
* **`scripts/`**: Automation scripts for building the image, transpiling Butane configs, embedding Ignition into the Live ISO, or deploying the OS.
* **`build/`**: The output directory for generated artifacts, such as the parsed `config.ign` files, custom ISO images, or generated SSH keys.
* **`packages/`**: A place to store loose RPMs or specialized binaries if you plan to install packages overlaying the base image.
* **`docs/`**: Project documentation, design notes, and application research checklists.

## Getting Started

1. Add your Butane configurations inside `config/butane/`.
2. Place custom files inside `rootfs/`.
3. Use your build scripts to generate the custom CoreOS image.

## Barbarous Editions

The distribution is carefully designed with multiple purpose-built editions tailored for specific use cases:

* **Barbarous Core** (Minimal)
* **Barbarous Station** (Desktop)
* **Barbarous Studio** (Creative/PKM)
* **Barbarous Edge** (IoT)
* **Barbarous Lab** (Dev/Net)
