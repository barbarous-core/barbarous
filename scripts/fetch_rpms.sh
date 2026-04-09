#!/usr/bin/env bash
# Barbarous Core RPM Fetcher
# Downloads RPMs and all dependencies into iso_assets/rpms.

RPM_DIR="/home/mohamed/barbarous/iso_assets/rpms"
mkdir -p "$RPM_DIR"

# List of tools marked as 'Layered' or 'Container' that should be available as RPMs
TOOLS=(
    "ncdu" "p7zip" "p7zip-plugins" "unzip" "htop" "powertop" "pass" "stow" "usbutils"
    "pcp" "smartmontools" "lm_sensors" "strace" "iotop" "zsh" "tmux" "firewalld"
    "nmap" "mtr" "tcpdump" "distrobox" "gcc" "gcc-c++" "make" "ruby" "samba"
    "rclone" "snapraid"
)

echo "==> Fetching RPMs and dependencies for ${#TOOLS[@]} tools..."

# We use --destdir to save them to our assets folder
# --resolve ensures all dependencies are also downloaded
# --alldeps ensures we get everything needed for an offline install
sudo dnf download --resolve --alldeps --destdir="$RPM_DIR" "${TOOLS[@]}"

echo "==> Done! Saved to $RPM_DIR"
echo "Total size: $(du -sh "$RPM_DIR" | cut -f1)"
