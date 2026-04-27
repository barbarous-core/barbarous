# Barbarous

Barbarous is a custom Linux distribution based on Fedora CoreOS.

## Project Structure

This project follows an edition-based layout for customizing and provisioning Fedora CoreOS images:

* **`assets/`**: General project assets, images, or static files.
* **`build/`**: Output directory for generated artifacts — Ignition configs, custom ISOs, or SSH keys. Also the download location for the base Fedora CoreOS ISO.
* **`docs/`**: Project documentation, including the [Barbarous Core: CLI Toolkit](docs/Barbarous_Core_CLI.md) and [Barbarous Core: Dotfiles & Configuration](docs/Barbarous_Dotfiles.md) catalogs.
* **`editions/`**: Edition-specific asset folders. **Barbarous Core is the base** — all other editions extend it. Each edition has its own subdirectory:
  * **`editions/<name>/butane/`**: Butane `.bu` configuration files (Core's butane is inherited by all editions).
  * **`editions/<name>/rpms/`**: RPM packages to be injected and installed on first boot.
  * **`editions/<name>/bin/`**: Static binaries for the edition.
  * **`editions/<name>/dotfiles/`**: Dotfiles and shell configurations.
  * **`editions/<name>/rootfs/`**: Files placed directly into the filesystem (e.g., `rootfs/etc/`, `rootfs/usr/local/bin/`).
* **`editions.json`**: The **master map** — declares each edition's assets, Butane sources, base ISO, and output ISO path.
* **`inbox/`**: Staging area for external resources, such as cloned dotfile repositories for research.
* **`iso_assets/`**: Holds the **Barbarous Core** edition's actual assets — `bin/` (static binaries), `dotfiles/` (compressed community configs), and `rpms/` — alongside Live ISO customization files.
* **`scratch/`**: Temporary directory for experimental files and one-off scripts.
* **`scripts/`**: Automation scripts for transpiling Butane, injecting assets, building ISOs, and [fetching community dotfiles](scripts/fetch_dotfiles.sh).

## Getting Started

1. **Download Base ISO**: Download the latest Fedora CoreOS live ISO from the [official Fedora CoreOS page](https://fedoraproject.org/coreos/download) and place it in the `build/` directory.
2. **RPM Injections**: Place any required `.rpm` packages into `editions/<name>/rpms/`. They will be installed on first boot via a generated systemd unit.
3. **Binary Injections**: Add custom static binaries to `editions/<name>/bin/`. They will be embedded into the Ignition config.
4. **Configurations**: Edit the Butane configs in `editions/<name>/butane/`. All non-core editions also inherit Core's `live-iso.bu` as their base.
5. **Fetch Dotfiles**: Run `scripts/fetch_dotfiles.sh` to automatically download and compress the community dotfile repositories listed in the documentation catalogs.
6. **Build ISO**: Run `scripts/inject_assets.sh <edition>` to transpile Butane, generate the Ignition config, and embed it into the base ISO using `coreos-installer`.

## Barbarous Editions

The distribution is carefully designed with multiple purpose-built editions tailored for specific use cases.

### In Progress

* **Barbarous Core** (Minimal)

### Roadmap (Planned Editions)

* **Barbarous Station** (Desktop)
* **Barbarous Studio** (Creative/PKM)
* **Barbarous Edge** (IoT)
* **Barbarous Lab** (Dev/Net)
* **Barbarous Touch** (Tablet)
