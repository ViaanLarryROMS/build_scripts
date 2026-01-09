repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs --no-clone-bundle && 
/opt/crave/resync.sh && 
git clone https://github.com/anshedu/android_device_oneplus_larry -b lineage-23.1 device/oneplus/larry && 
git clone https://github.com/anshedu/android_device_oneplus_sm6375-common -b lineage-23.1 device/oneplus/sm6375-common && 
git clone https://github.com/anshedu/proprietary_vendor_oneplus_larry -b lineage-23.1 vendor/oneplus/larry && 
git clone https://github.com/anshedu/proprietary_vendor_oneplus_sm6375-common -b lineage-23.1 vendor/oneplus/sm6375-common &&
git clone https://github.com/anshedu/android_kernel_oneplus_sm6375 -b lineage-23.1 kernel/oneplus/sm6375 && 
git clone https://github.com/anshedu/android_hardware_oplus -b lineage-23.1 hardware/oplus && 
source build/envsetup.sh && 
brunch larry
