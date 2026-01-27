# Nuke All Previous Things
rm -rf Dvox


# Initialise and Sync the Source
mkdir LumineDroid
cd LumineDroid


repo init -u https://github.com/LumineDroid/platform_manifest -b bellflower --git-lfs
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j8

# Sync the trees
git clone https://github.com/ViaanLarryROMS/android_device_oneplus_larry -b LumineDroid device/oneplus/larry
git clone https://github.com/Teamhackneyed/android_device_oneplus_sm6375-common -b lineage-23.2 device/oneplus/sm6375-common
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_larry -b lineage-23.2 vendor/oneplus/larry
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_sm6375-common -b lineage-23.2 vendor/oneplus/sm6375-common
git clone https://github.com/Teamhackneyed/android_kernel_oneplus_sm6375 -b lineage-23.2 kernel/oneplus/sm6375
git clone https://github.com/Teamhackneyed/android_hardware_oplus -b lineage-23.2 hardware/oplus

# BUILDDD

source build/envsetup.sh

lunch larry-bp4a-userdebug

mka bacon

