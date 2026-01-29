#!/bin/bash

# === CONFIGURATION (Edit these) ===
DEVICE_CODENAME="spaced"
# The actual URL of your device tree (Replace this with the real link!)
DEVICE_REPO="https://github.com/daizeuz-dred/android_device_realme_spaced_pbrp"
DEVICE_BRANCH="android-12.1"
DEVICE_PATH="device/realme/spaced"
BUILD_DIR="$HOME/pbrp_build"
# =================================

# Exit on error
set -e

# Function to install dependencies
install_dependencies() {
    echo "--- Installing dependencies ---"
    sudo pacman -Syu --needed --noconfirm \
        bc base-devel zip curl libstdc++5 git wget python \
        openssh lvm2 openssl rsync
}

# Function to sync PBRP source code
sync_pbrp_source() {
    echo "--- Syncing PBRP source (this may take a while) ---"
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"

    # Configure Git if not already set
    git config --global user.email "daizeuzdred@gmail.com" || true
    git config --global user.name "Deeznutz" || true
}

# Function to clone device tree
clone_device_tree() {
    echo "--- Cloning device tree ---"
    cd "$BUILD_DIR"
    # Ensure the target directory is clean
    rm -rf "$DEVICE_PATH"
    git clone "$DEVICE_REPO" -b "$DEVICE_BRANCH" "$DEVICE_PATH"
}

# Function to build
build_recovery() {
    echo "--- Starting Build ---"
    cd "$BUILD_DIR"

    # Set up environment
    source build/envsetup.sh

    # Crucial flag for Android 12.1+ builds
    export ALLOW_MISSING_DEPENDENCIES=true

    # Lunch the device
    lunch "pbrp_${DEVICE_CODENAME}-eng" || lunch "omni_${DEVICE_CODENAME}-eng"

    # Build PBRP
    mka pbrp -j$(nproc --all)
}

# Execution Flow
install_dependencies
sync_pbrp_source
clone_device_tree
build_recovery

echo "Build process finished! Check $BUILD_DIR/out/target/product/$DEVICE_CODENAME/"
