LOCAL_PATH := device/samsung/gts2-common

PRODUCT_CHARACTERISTICS := tablet

# API
#error: found duplicate sysprop assignments:
#ro.vndk.version=current
#ro.vndk.version=34
#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.vndk.version=current

# APN Definitions - override incomplete/broken lineageos version with Samsung version
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/telephony/apns-conf.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/apns-conf.xml \
    $(LOCAL_PATH)/configs/telephony/spn-conf.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/spn-conf.xml

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    audio.bluetooth.default \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    audio.primary.universal5433 \
    audio.r_submix.default \
    audio.usb.default \
    libtinycompress \
    libcsc
#   libseirenhw \

	
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# This HAL (hardware/samsung/audio/audio_hw.c) has no idle timer of its own;
# AudioFlinger alone decides when to call out_standby() on an output thread
# (default 3s of silence, see kDefaultStandbyTimeInNsecs). Every standby->
# active transition re-does enable_output_path_l()+pcm_open() from a cold
# analog/codec power-up, and short UI "touch sound" clicks (a few hundred ms)
# played right after that cold start land partly inside the speaker amp/DAC's
# power-up settling time, so the same click sounds louder or quieter
# depending on how long the output had been idle. Confirmed on-device: the
# first tap after any pause is the one that sounds off, back-to-back taps
# sound consistent - exactly the standby/cold-reopen signature. 30s wasn't
# long enough to cover realistic pauses between taps during normal use
# (reading a screen, deciding what to tap next), so raise it well past
# typical human pause lengths.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.audio.flinger_standbytime_ms=120000

# Additional native libraries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service \
    libbt-vendor

PRODUCT_PROPERTY_OVERRIDES += \
    ro.bt.bdaddr_path="/efs/bluetooth/bt_addr"

# BPF - needed for ultra legacy devices
PRODUCT_PROPERTY_OVERRIDES += \
    ro.kernel.ebpf.supported=false

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    camera.device@1.0-impl \
    libion_exynos \
    libexynoscamera_shim \
    libstagefright_shim

# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Codecs
PRODUCT_PACKAGES += \
    libExynosOMX_Core \
    libstagefrighthw

# Configstore
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3

# Display
#PRODUCT_PACKAGES += \
#   AdvancedDisplay

# APEX
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/ld.config.txt:$(TARGET_COPY_OUT_SYSTEM)/etc/swcodec/ld.config.txt

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay-service.samsung-exynos

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.3 \
    android.hardware.drm-service.clearkey

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.samsung

# Flat device tree for boot image
PRODUCT_HOST_PACKAGES += \
    dtbhtoolExynos

# First Model API LEVEL
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_l.mk)

# Gatekeeper
# Real TEE-backed gatekeeper (talks to the same mobicore TEE as fingerprint),
# replacing the AOSP software fallback. The software HAT it issued couldn't be
# validated by the bauth fingerprint trustlet (TLC_BAUTH: "Trustlet did not
# send a valid return code"), since it isn't signed by anything the TEE trusts.
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.gatekeeper@1.0-impl \
    gatekeeper.universal5433

# Gps
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl.universal5433 \
    android.hardware.gnss@1.0-service.universal5433 \
    libshim_gpsd \
    libshim_icuuc \
    libutils-v32

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf \
    $(LOCAL_PATH)/configs/gps/gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/gps.xml \
    $(LOCAL_PATH)/configs/gps/gnss.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss.conf

# Graphics
PRODUCT_AAPT_CONFIG := xlarge
PRODUCT_AAPT_PREF_CONFIG := xhdpi
PRODUCT_AAPT_PREBUILT_DPI := hdpi mdpi

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    libfimg \
    libhwc2on1adapter \
    libion

# Lineage Health
$(call soong_config_set,lineage_health,charging_control_charging_path,/sys/class/power_supply/battery/batt_slate_mode)
$(call soong_config_set,lineage_health,charging_control_charging_enabled,0)
$(call soong_config_set,lineage_health,charging_control_charging_disabled,1)
$(call soong_config_set_bool,lineage_health,charging_control_supports_bypass,false)

PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

# Healthd
PRODUCT_PACKAGES += \
    android.hardware.health-service.example

# LPM
PRODUCT_PACKAGES += \
    libsuspend

# HIDL
PRODUCT_PACKAGES += \
    libhwbinder \
    libhidltransport \
    vndservicemanager

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/idc/ft5x06_ts.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/ft5x06_ts.idc \
    $(LOCAL_PATH)/configs/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/configs/keylayout/sec_touchkey.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/sec_touchkey.kl

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1-service

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.samsung

# Media
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml  \
    $(LOCAL_PATH)/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Memory
PRODUCT_PACKAGES += \
    memtrack.exynos5

# MobiCore
#PRODUCT_PACKAGES += \
#   mcDriverDaemon

# Net
PRODUCT_PACKAGES += \
    android.system.net.netd@1.0 \
    libandroid_net \
    netutils-wrapper-1.0

# OMX
#PRODUCT_PACKAGES += \
#    android.hardware.media.omx@1.0-service

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    device/samsung/gts2-common/overlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_0_3.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml

# Power
PRODUCT_PACKAGES += \
     android.hardware.power-service.lineage-libperfmgr

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.universal5433 \
    init.fingerprint.rc \
    init.gatekeeper.rc \
    init.samsung.rc \
    init.universal5433.rc \
    init.universal5433.usb.rc \
    init.wifi.rc \
    ueventd.universal5433.rc

# First-stage init (which runs before /vendor is mounted) looks for the
# fstab in the boot ramdisk; the fstab.universal5433 PRODUCT_PACKAGES
# module above only places it under TARGET_OUT_VENDOR_ETC, which isn't
# available yet at that point. The kernel's own android,fstab devicetree
# node (with just a "system" entry) isn't a fallback either -- modern
# libfstab's ReadDefaultFstab() no longer reads devicetree-embedded fstab
# entries at all, only files. Without this, init panics at boot with
# "Failed to create FirstStageMount".
#
# This must land under TARGET_RAMDISK_OUT ("ramdisk/"), not TARGET_ROOT_OUT
# ("root/"): modern AOSP builds boot.img's ramdisk from
# INTERNAL_RAMDISK_FILES, which build/make/core/Makefile defines as
# whatever was installed under TARGET_RAMDISK_OUT specifically -- confirmed
# by unpacking an actual built boot.img and finding only the generic
# ramdisk skeleton (init, dev/, metadata, second_stage_resources) with
# nothing device-specific, after an earlier attempt placed this file under
# TARGET_ROOT_OUT instead and the same panic recurred on real hardware.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.universal5433:ramdisk/fstab.universal5433

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# RRO
PRODUCT_ENFORCE_RRO_TARGETS := \
    framework-res

# Seccomp policy
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Update
AB_OTA_UPDATER := false
PRODUCT_SOONG_NAMESPACES += \
    bootable/deprecated-ota


# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/samsung \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/lineage/interfaces/power-libperfmgr

# System
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.binary_xml=false

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.basic

# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.build.vendor_security_patch=2018-01-05

# VNDK
PRODUCT_PACKAGES += \
    libprotobuf-cpp-lite-v29 \
    libhidlbase-v32

# Wifi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0 \
    android.hardware.wifi-service \
    hostapd \
    libwpa_client \
    macloader \
    wificond \
    wifiloader \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# call Samsung LSI board support package
$(call inherit-product, hardware/samsung_slsi/exynos5/exynos5.mk)
$(call inherit-product, hardware/samsung_slsi/exynos5433/exynos5433.mk)

# Vendor
$(call inherit-product, vendor/samsung/gts2-common/gts2-common-vendor.mk)
