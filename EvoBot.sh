# --- Configuration ---
TG_TOKEN="7411075899:AAGnxmLAEv9HK4nBxUC5GfejNkkhaP3DOLc"
TG_CHAT="7756304067"
DATE=$(date +%Y%m%d)

tg_msg() {
    curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
    -d chat_id="$TG_CHAT" -d parse_mode="Markdown" -d text="$1" > /dev/null
}

# 0. Initial Test Message
tg_msg "123"

# 1. Initialize and Sync (Your fallback logic)
repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs
SYNC_OK=0
repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j16 && SYNC_OK=1 || SYNC_OK=0

if [ "$SYNC_OK" -ne 1 ]; then
  repo sync -c --no-clone-bundle --optimized-fetch --get-lfs --prune --force-sync -j8 && SYNC_OK=1 || SYNC_OK=0
fi
if [ "$SYNC_OK" -ne 1 ]; then
  repo sync -c --no-clone-bundle --optimized-fetch --get-lfs --prune --force-sync -j4 && SYNC_OK=1 || SYNC_OK=0
fi
if [ "$SYNC_OK" -ne 1 ]; then
  repo sync -j1 --fail-fast
fi

# 2. Clone Trees
git clone https://github.com/ViaanLarryROMS/android_device_oneplus_larry -b lineage-23.2 device/oneplus/larry && \
git clone https://github.com/Teamhackneyed/android_device_oneplus_sm6375-common -b lineage-23.2 device/oneplus/sm6375-common && \
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_larry -b lineage-23.2 vendor/oneplus/larry && \
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_sm6375-common -b lineage-23.2 vendor/oneplus/sm6375-common && \
git clone https://github.com/Teamhackneyed/android_kernel_oneplus_sm6375 -b lineage-23.2 kernel/oneplus/sm6375 && \
git clone https://github.com/LineageOS/android_hardware_oplus -b lineage-23.2 hardware/oplus

# 3. Vanilla Build
START_V=$(date +%s)
tg_msg "🔨 *Build Started:* Vanilla EvolutionX ($DATE)"

. build/envsetup.sh
lunch lineage_larry-bp4a-userdebug
make installclean

# Run build and capture output to log
m evolution 2>&1 | tee build_log_vanilla.txt

# Process Vanilla Output
ZIP_V=$(find out/target/product/larry/ -maxdepth 1 -name "EvolutionX*.zip" | head -n 1)
if [ -f "$ZIP_V" ]; then
    DIFF_V=$(( ($(date +%s) - START_V) / 60 ))
    rclone copy "$ZIP_V" gd:EvolutionX/larry/vanilla/ --progress
    gh release create "VANILLA-$DATE" "$ZIP_V" --title "Vanilla-$DATE" --notes "Build Time: $DIFF_V minutes"
    tg_msg "✅ *Vanilla Uploaded!*%0ATime: $DIFF_V mins%0AFile: \`$(basename $ZIP_V)\`"
else
    # SCRAPE ERROR LOG
    ERROR_V=$(grep -A 3 "FAILED:" build_log_vanilla.txt | tail -n 8)
    tg_msg "❌ *Vanilla Build Failed!*%0A%0A*Log Snippet:*%0A\`\`\`%0A$ERROR_V%0A\`\`\`"
fi

# 4. GApps Build (Swap lineage_larry.mk)
cd device/oneplus/larry
if [ -f "gapps.txt" ]; then
    mv lineage_larry.mk lineage_larry_vanilla.mk_bak
    mv gapps.txt lineage_larry.mk
fi
cd ../../..

START_G=$(date +%s)
tg_msg "🔨 *Build Started:* GApps EvolutionX ($DATE)"

. build/envsetup.sh
lunch lineage_larry-bp4a-userdebug
make installclean

# Run build and capture output to log
m evolution 2>&1 | tee build_log_gapps.txt

# Process GApps Output
ZIP_G=$(find out/target/product/larry/ -maxdepth 1 -name "EvolutionX*.zip" | head -n 1)
if [ -f "$ZIP_G" ]; then
    DIFF_G=$(( ($(date +%s) - START_G) / 60 ))
    rclone copy "$ZIP_G" gd:EvolutionX/larry/gapps/ --progress
    gh release create "GAPPS-$DATE" "$ZIP_G" --title "GApps-$DATE" --notes "Build Time: $DIFF_G minutes"
    tg_msg "✅ *GApps Uploaded!*%0ATime: $DIFF_G mins%0AFile: \`$(basename $ZIP_G)\`"
else
    # SCRAPE ERROR LOG
    ERROR_G=$(grep -A 3 "FAILED:" build_log_gapps.txt | tail -n 8)
    tg_msg "❌ *GApps Build Failed!*%0A%0A*Log Snippet:*%0A\`\`\`%0A$ERROR_G%0A\`\`\`"
fi
