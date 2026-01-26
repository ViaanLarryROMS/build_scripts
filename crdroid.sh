# Make Folders
rm -rf YAAP
mkdir -p ~/crDroid
cd ~/crDroid

# Sync the source
repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs --no-clone-bundle
repo sync -c --force-sync --no-tags --no-clone-bundle -j8

# Sync the trees
git clone https://github.com/Teamhackneyed/android_device_oneplus_larry -b lineage-23.2 device/oneplus/larry
git clone https://github.com/Teamhackneyed/android_device_oneplus_sm6375-common -b lineage-23.2 device/oneplus/sm6375-common
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_larry -b lineage-23.2 vendor/oneplus/larry
git clone https://github.com/Teamhackneyed/proprietary_vendor_oneplus_sm6375-common -b lineage-23.2 vendor/oneplus/sm6375-common
git clone https://github.com/Teamhackneyed/android_kernel_oneplus_sm6375 -b lineage-23.2 kernel/oneplus/sm6375
git clone https://github.com/Teamhackneyed/android_hardware_oplus -b lineage-23.2 hardware/oplus

# Build
source build/envsetup.sh
brunch larry
