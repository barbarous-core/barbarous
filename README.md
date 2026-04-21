# Barbarous

Barbarous is a custom Linux distribution based on Fedora CoreOS.

## Project Structure

This project follows a standard layout for customizing immutable Linux distributions like Fedora CoreOS:

* **`assets/`**: General project assets, images, or static files.
* **`build/`**: The output directory for generated artifacts, such as the parsed `config.ign` files, custom ISO images, or generated SSH keys.
* **`config/butane/`**: Stores your Butane (`.bu`) configuration files which are transpiled to Ignition configs for first-boot provisioning.
* **`docs/`**: Project documentation, design notes, and application research checklists.
* **`inbox/`**: A staging area for external resources, such as cloned dotfile repositories for research and integration.
* **`iso_assets/`**: Assets specifically required for building and customizing the Live ISO (e.g., bootloader configs, custom graphics).
* **`packages/`**: A place to store loose RPMs or specialized binaries if you plan to install packages overlaying the base image.
* **`rootfs/`**: Contains files and directories that will be placed directly into the file system (e.g., custom configuration files in `rootfs/etc/` or static binaries in `rootfs/usr/local/bin/`).
* **`scratch/`**: Temporary directory for experimental files, one-off scripts, or scratch data.
* **`scripts/`**: Automation scripts for building the image, transpiling Butane configs, embedding Ignition into the Live ISO, or deploying the OS.

## Getting Started

1. **RPM Injections**: Place any required `.rpm` packages into the `packages/` directory to be overlaid onto the base image.
2. **Binary Injections**: Add custom static binaries directly to their target path within the `rootfs/` directory (e.g., `rootfs/usr/local/bin/`).
3. **Configurations**: Add your Butane configurations inside `config/butane/` and place any other custom system files into the corresponding paths in `rootfs/`.
4. **Build ISO**: Execute your build scripts (located in `scripts/`) to generate the custom CoreOS ISO, which will automatically inject the RPMs and binaries into the final image.

## Barbarous Editions

The distribution is carefully designed with multiple purpose-built editions tailored for specific use cases:

* **Barbarous Core** (Minimal)
* **Barbarous Station** (Desktop)
* **Barbarous Studio** (Creative/PKM)
* **Barbarous Edge** (IoT)
* **Barbarous Lab** (Dev/Net)
* **Barbarous Touch** (Tablet)
