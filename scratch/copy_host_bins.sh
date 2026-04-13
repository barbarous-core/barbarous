#!/usr/bin/env bash
# Gathering host-installed kmscon and bicon into the project bundle

PROJECT_ROOT="/home/mohamed/barbarous"
BUNDLE_DIR="$PROJECT_ROOT/iso_assets/bin/bundle"
LIB_DIR="$BUNDLE_DIR/lib"
SHARE_DIR="$BUNDLE_DIR/share"

echo "==> Preparing bundle directory..."
mkdir -p "$LIB_DIR"
mkdir -p "$SHARE_DIR"

echo "==> Copying binaries..."
# bicon
cp /usr/bin/bicon.bin "$BUNDLE_DIR/"
cp /usr/bin/bicon "$BUNDLE_DIR/bicon.host_script"
# kmscon
cp /usr/libexec/kmscon/kmscon "$BUNDLE_DIR/"
cp /usr/bin/kmscon "$BUNDLE_DIR/kmscon.host_script"

echo "==> Copying libraries and modules..."
# libtsm
cp /usr/lib64/libtsm.so.4* "$LIB_DIR/"
# bicon libs
cp /usr/lib64/bicon/libbconsole.so* "$LIB_DIR/"
cp /usr/lib64/bicon/libbjoining.so* "$LIB_DIR/"
# kmscon modules
mkdir -p "$LIB_DIR/kmscon"
cp /usr/lib64/kmscon/mod-*.so "$LIB_DIR/kmscon/"

echo "==> Copying data files..."
cp -r /usr/share/bicon "$SHARE_DIR/"

echo "==> Gathering shared dependencies via ldd..."
# Gather dependencies for the real ELF binaries
REAL_BINS=("/usr/libexec/kmscon/kmscon" "/usr/bin/bicon.bin")
for bin in "${REAL_BINS[@]}"; do
    # Filter for libraries that are likely not in a minimal FCOS or are version-sensitive
    # We'll grab libfribidi, libpango, libharfbuzz, etc.
    deps=$(ldd "$bin" | grep "=>" | awk '{print $3}' | grep -E "fribidi|pango|harfbuzz|tsm|drm|xkbcommon|udev")
    for dep in $deps; do
        if [ -f "$dep" ]; then
            cp -d "$dep" "$LIB_DIR/" 2>/dev/null
        fi
    done
done

echo "✅ Files copied from host to $BUNDLE_DIR"
