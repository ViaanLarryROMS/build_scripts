# Initialize local repository
repo init -u https://github.com/AviumUI/android_manifests -b avium-16 --git-lfs &&

# Sync
/opt/crave/resync.sh && 

# Copy Trees
git clone https://github.com/ViaanLarryROMS/android_device_oneplus_larry_dt -b aviumui device/oneplus/larry &&
git clone https://github.com/anshedu/android_device_oneplus_sm6375-common -b lineage-23.0 device/oneplus/sm6375-common && 
git clone https://github.com/anshedu/proprietary_vendor_oneplus_larry -b lineage-23.0 vendor/oneplus/larry && 
git clone https://github.com/anshedu/proprietary_vendor_oneplus_sm6375-common -b lineage-23.0 vendor/oneplus/sm6375-common && 
git clone https://github.com/anshedu/android_kernel_oneplus_sm6375 -b lineage-23.0 kernel/oneplus/sm6375 && 
git clone https://github.com/anshedu/android_hardware_oplus -b lineage-23.0 hardware/oplus &&

# BUILDD
source build/envsetup.sh &&
lunch lineage_larry-bp2a-userdebug &&
m bacon

# Build
source build/envsetup.sh &&
lunch lineage_larry-bp2a-userdebug &&
m bacon -j12

