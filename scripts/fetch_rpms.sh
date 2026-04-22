#!/usr/bin/env bash
# Barbarous Core RPM Fetcher
# Downloads RPMs and all dependencies into iso_assets/rpms.

RPM_DIR="/home/mohamed/barbarous/iso_assets/rpms"
mkdir -p "$RPM_DIR"

# Dynamically get the list of RPMs from our assets.json
TOOLS=($(python3 scripts/get_rpm_list.py))

if [ ${#TOOLS[@]} -eq 0 ]; then
    echo "==> Error: No RPMs found in assets.json. Run generate_edition_assets.py first."
    exit 1
fi

echo "==> Fetching RPMs and dependencies for ${#TOOLS[@]} tools..."

# We use --destdir to save them to our assets folder
# --resolve ensures all dependencies are also downloaded
# --alldeps ensures we get everything needed for an offline install
sudo dnf download --resolve --alldeps --destdir="$RPM_DIR" "${TOOLS[@]}"

echo "==> Done! Saved to $RPM_DIR"
echo "Total size: $(du -sh "$RPM_DIR" | cut -f1)"
