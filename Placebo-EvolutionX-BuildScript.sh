#!/bin/bash

# --- 1. Repo Init & Your Specific Sync Logic ---
repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs &&
SYNC_OK=0
repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j16 && SYNC_OK=1 || SYNC_OK=0

if [ "$SYNC_OK" -ne 1 ]; then
  repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j8 && SYNC_OK=1 || SYNC_OK=0
fi
if [ "$SYNC_OK" -ne 1 ]; then
  repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j4 && SYNC_OK=1 || SYNC_OK=0
fi
if [ "$SYNC_OK" -ne 1 ]; then
  repo sync -j1 --fail-fast
fi

# --- 2. Clone Trees ---
git clone https://github.com/ViaanLarryROMS/android_device_oneplus_larry -b lineage-23.2 device/oneplus/larry && \
git clone https://github.com/Teamhackneyed/android_device_oneplus_sm6375-common -b lineage-23.2 device/oneplus/sm6375-common && \
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_larry -b lineage-23.2 vendor/oneplus/larry && \
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_sm6375-common -b lineage-23.2 vendor/oneplus/sm6375-common && \
git clone https://github.com/Teamhackneyed/android_kernel_oneplus_sm6375 -b lineage-23.2 kernel/oneplus/sm6375 && \
git clone https://github.com/LineageOS/android_hardware_oplus -b lineage-23.2 hardware/oplus

# --- 3. Vanilla Build & Upload ---
. build/envsetup.sh
lunch lineage_larry-bp4a-userdebug
make installclean
m evolution

# Detect the exact zip name for Vanilla
VANILLA_ZIP=$(find out/target/product/larry -maxdepth 1 -name "EvolutionX*.zip" | head -n 1)
if [ -f "$VANILLA_ZIP" ]; then
    echo "Uploading Vanilla Build: $(basename "$VANILLA_ZIP")"
    rclone copy "$VANILLA_ZIP" gd:EvolutionX/larry/vanilla/ --progress
fi

# --- 4. GApps Build & Upload ---
# Swap configs: backup vanilla, move gapps.txt to larry.mk
cd device/oneplus/larry && mv larry.mk larry_vanilla.mk && mv gapps.txt larry.mk && cd ../../..

. build/envsetup.sh
lunch lineage_larry-bp4a-userdebug
make installclean
m evolution

# Detect the exact zip name for GApps
GAPPS_ZIP=$(find out/target/product/larry -maxdepth 1 -name "EvolutionX*.zip" | head -n 1)
if [ -f "$GAPPS_ZIP" ]; then
    echo "Uploading GApps Build: $(basename "$GAPPS_ZIP")"
    rclone copy "$GAPPS_ZIP" gd:EvolutionX/larry/gapps/ --progress
fi

echo "All builds complete and uploaded!"
