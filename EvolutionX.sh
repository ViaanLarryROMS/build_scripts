
repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs && \
/opt/crave/resync.sh && \
git clone https://github.com/ViaanLarryROMS/android_device_oneplus_larry -b lineage-23.1 device/oneplus/larry && \
git clone https://github.com/anshedu/android_device_oneplus_sm6375-common -b lineage-23.1 device/oneplus/sm6375-common && \
git clone https://github.com/anshedu/proprietary_vendor_oneplus_larry -b lineage-23.1 vendor/oneplus/larry && \
git clone https://github.com/anshedu/proprietary_vendor_oneplus_sm6375-common -b lineage-23.1 vendor/oneplus/sm6375-common && \
git clone https://github.com/anshedu/android_kernel_oneplus_sm6375 -b lineage-23.1 kernel/oneplus/sm6375 && \
git clone https://github.com/anshedu/android_hardware_oplus -b lineage-23.1 hardware/oplus && \
# Vanilla Build
. build/envsetup.sh && \
lunch lineage_larry-bp2a-user && make installclean && m evolution; \
rm -rf out/target/product/vanilla && rm -rf out/target/product/gapps; \
cd out/target/product && mv larry vanilla && cd ../../..; \
# Gapps Build
cd device/oneplus/larry && rm larry.mk && mv gapps.txt larry.mk && cd ../../..; \
. build/envsetup.sh; \
lunch lineage_larry-bp2a-user && make installclean && m evolution; \
cd out/target/product && mv larry g
