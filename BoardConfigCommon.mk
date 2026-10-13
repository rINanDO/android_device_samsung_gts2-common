LOCAL_PATH := device/samsung/gts2-common

### PLATFORM

TARGET_ARCH := arm
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

BOARD_VENDOR := samsung

# CPU
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := cortex-a53

# Platform
TARGET_BOARD_PLATFORM := exynos5
TARGET_SLSI_VARIANT := bsp
TARGET_SOC := exynos5433

# big.LITTLE load balancing
#ENABLE_CPUSETS := true

TARGET_BOOTLOADER_BOARD_NAME := universal5433

# Audio
USE_XML_AUDIO_POLICY_CONF := 1

# Binder
# TARGET_USES_64_BIT_BINDER := true

### FILESYSTEM

BOARD_BOOTIMAGE_PARTITION_SIZE := 14680064
BOARD_CACHEIMAGE_PARTITION_SIZE := 209715200
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3145728000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 27657240576
BOARD_FLASH_BLOCK_SIZE := 4096

BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_KERNEL_HAVE_EXFAT := true
TARGET_KERNEL_HAVE_NTFS := true

# Extended Filesystem Support
TARGET_EXFAT_DRIVER := sdfat

BOARD_RAMDISK_USE_XZ := true

BOARD_ROOT_EXTRA_FOLDERS += efs
TARGET_FS_CONFIG_GEN := $(LOCAL_PATH)/config.fs

BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

### KERNEL
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_SEPARATED_DT := true
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01000000 --tags_offset 0x00000100
TARGET_CUSTOM_DTBTOOL := dtbhtoolExynos
BOARD_CUSTOM_BOOTIMG := true
BOARD_CUSTOM_BOOTIMG_MK := hardware/samsung/mkbootimg.mk
TARGET_KERNEL_SOURCE := kernel/samsung/universal5433
KERNEL_ARCH := arm
KERNEL_TOOLCHAIN_PREFIX := arm-linux-androideabi-
BOARD_KERNEL_IMAGE_NAME := zImage
TARGET_LINUX_KERNEL_VERSION := 3.10
TARGET_KERNEL_CLANG_COMPILE := false

# This 3.10 kernel predates clang-built-linux support, so it needs the GCC
# cross-compiler vendor/lineage/build/tasks/kernel.mk otherwise defaults away
# from (it falls back to clang whenever KERNEL_CC is unset). KERNEL_TOOLCHAIN_PREFIX
# above is a vestige of an older kernel.mk that read it directly; the current one
# only understands KERNEL_CC/KERNEL_CROSS_COMPILE.
BUILD_TOP := $(abspath .)
GTS210WIFI_GCC_PATH := $(abspath prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-)
KERNEL_CC := CC=$(GTS210WIFI_GCC_PATH)gcc
KERNEL_CROSS_COMPILE := CROSS_COMPILE=$(GTS210WIFI_GCC_PATH)
KERNEL_MAKE_CMD := $(abspath prebuilts/build-tools/linux-x86/bin/make)

# The kernel's host tools (fixdep, unifdef, conf, ...) build with HOSTCC/HOSTCXX,
# which default to the bare "gcc"/"g++" names on $PATH. That's fine for the real
# kernel.mk build task (which inherits the invoking shell's PATH), but
# generated_kernel_includes' Soong genrule runs this same make invocation inside
# an sbox sandbox whose PATH is restricted to prebuilts/build-tools' hermetic
# tool set -- no system gcc there -- so HOSTCC must be pinned to a prebuilt
# that's actually on that PATH, or the genrule fails with "gcc: not found" on
# scripts/basic/fixdep and silently produces no headers.
# Must match the version Soong actually builds everything else with
# (build/soong/cc/config/global.go's ClangDefaultVersion); multiple clang-r*
# prebuilts coexist in the tree for different purposes, so this can't be
# glob-guessed safely and has to track that value by hand.
GTS210WIFI_HOST_CLANG_PATH := $(abspath prebuilts/clang/host/linux-x86/clang-r584948b/bin)
KERNEL_MAKE_FLAGS := HOSTCC=$(GTS210WIFI_HOST_CLANG_PATH)/clang HOSTCXX=$(GTS210WIFI_HOST_CLANG_PATH)/clang++

# vendor/lineage/build/soong/Android.bp's generated_kernel_includes genrule
# (what build/make/core/binary.mk's "old-style kernel header include" ->
# generated_kernel_headers translation ultimately pulls in) expands its cmd
# against the lineageVarsPlugin soong config namespace, same as
# vendor/lineage/config/BoardConfigSoong.mk's EXPORT_TO_SOONG list does for
# devices that include it. This device doesn't, so without this nothing is
# exported, the genrule silently emits no headers (see
# vendor/lineage/build/soong/generator/generator.go's graceful skip for
# modules referencing unexported vars), and anything still relying on the
# old $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include path -- such as
# hardware/samsung_slsi/exynos/libexynosutils -- fails with a missing
# kernel UAPI header instead.
OUT_DIR_PREFIX := $(shell echo $(OUT_DIR) | sed -e 's|/target/.*$$||g')
ifeq ($(OUT_DIR_PREFIX),out)
    KERNEL_BUILD_OUT_PREFIX := $(BUILD_TOP)/
endif
$(call add_soong_config_namespace,lineageVarsPlugin)
$(foreach v,KERNEL_ARCH KERNEL_BUILD_OUT_PREFIX KERNEL_CROSS_COMPILE \
        KERNEL_MAKE_CMD KERNEL_MAKE_FLAGS KERNEL_PATH PATH_OVERRIDE_SOONG \
        TARGET_KERNEL_CONFIG TARGET_KERNEL_SOURCE TARGET_KERNEL_PLATFORM_TARGET \
        TARGET_MAX_PAGE_SIZE_SUPPORTED TARGET_PREBUILT_KERNEL_HEADERS, \
    $(eval $(call add_soong_config_var,lineageVarsPlugin,$(v))))

# Ant+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Audio
BOARD_USE_ALP_AUDIO := true

# Audio HAL variant
TARGET_AUDIOHAL_VARIANT := samsung

# Bootanimation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true
TARGET_SCREEN_HEIGHT := 2048
TARGET_SCREEN_WIDTH := 1536

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
PRODUCT_SOONG_NAMESPACES += hardware/broadcom/libbt
$(call soong_config_set,brcm_libbt,custom_bt_config,//$(LOCAL_PATH):vnd_exynos5433.txt)
$(call soong_config_set,brcm_libbt,bdroid_buildcfg_include_dir,$(LOCAL_PATH)/bluetooth)

# Camera
$(call soong_config_set,camera_hal1,no_cameraserver,true)
BOARD_USE_SAMSUNG_CAMERAFORMAT_NV21 := true

# Charger/Healthd
BOARD_CHARGING_MODE_BOOTING_LPM := /sys/class/power_supply/battery/batt_lp_charging
CHARGING_ENABLED_PATH := /sys/class/power_supply/battery/batt_lp_charging

# Dexpreopt
ifeq ($(HOST_OS),linux)
  ifneq ($(TARGET_BUILD_VARIANT),eng)
    WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY ?= false
    WITH_DEXPREOPT := true
  endif
endif

# Display
TARGET_SCREEN_DENSITY := 320

# FIMG2D
BOARD_USES_SKIA_FIMGAPI := true
BOARD_USES_NEON_BLITANTIH := true
BOARD_USES_FIMGAPI_V4L2 := false

# Fingerprint
#TARGET_SEC_FP_CALL_NOTIFY_ON_CANCEL := true
#TARGET_SEC_FP_USES_PERCENTAGE_SAMPLES := true
#TARGET_SEC_FP_CALL_CANCEL_ON_ENROLL_COMPLETION := true

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# Graphics
USE_OPENGL_RENDERER := true

# This device's gralloc HAL (hardware/samsung_slsi/exynos/gralloc) is the
# legacy pre-Treble gralloc0 hw_module_t, wrapped only up to HIDL
# allocator@2.0/mapper@2.0-2.1. Current libui's GraphicBufferMapper
# requires a real gralloc mapper@4.0+ implementation unless this flag is
# set, skipping the mapper@2.x/3.x fallback entirely and aborting with
# "gralloc-mapper is missing" -- confirmed from a real device boot log,
# after confirming via GraphicBufferMapper.cpp that LEGACY_GRALLOC is
# precisely the escape hatch for this.
$(call soong_config_set_bool,libui,legacy_gralloc,true)

# With LEGACY_GRALLOC enabled, this device's gralloc.cpp (which still uses
# the real ioctl-based ION userspace API) finally gets invoked for actual
# buffer allocation -- but system/memory/libion/ion.c was turned into a
# permanent no-op stub (always returns -1) in AOSP, since upstream ION
# kernel support is being dropped ("All kernels with ION support will
# reach end of life in December 2025"). This device's 3.10 kernel is a
# real, still-functional CONFIG_ION_EXYNOS=y ION driver, so every
# allocation failed immediately, surfaceflinger's RenderEngine got a
# non-GPU-writeable output buffer, and it aborted -- confirmed from a
# real device boot log. libion/Android.bp already supports switching back
# to the real ioctl-based implementation (ion_legacy.c/include_legacy)
# via this exact flag; no source restoration needed.
$(call soong_config_set_bool,libion,legacy_impl,true)

# Low memory devices
MALLOC_SVELTE := true

# remove this driver as we are using 5433 R22P0 now
# BOARD_USES_EXYNOS5_COMMON_GRALLOC := true
BOARD_USES_EXYNOS5_COMMON_GRALLOC := false

# (G)SCALER
BOARD_USES_SCALER := true
BOARD_USES_DT := true

# Gralloc
TARGET_USES_GRALLOC1_ADAPTER := true

# ION
TARGET_USES_ION := true

# Hidl
#DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/manifest.xml
#PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true
			   
# Lineage hardware
ifneq ($(findstring lineage, $(TARGET_PRODUCT)),)
JAVA_SOURCE_OVERLAYS := \
    org.lineageos.hardware|$(LOCAL_PATH)/lineagehw|**/*.java
endif

# HDMI
BOARD_HDMI_INCAPABLE := true

# Hidl
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    hardware/lineage/interfaces/compatibility_matrices/compatibility_matrix.lineage.xml  \
    $(LOCAL_PATH)/manifest/framework_compatibility_matrix.xml
DEVICE_MANIFEST_FILE := device/samsung/gts2-common/manifest.xml
DEVICE_MATRIX_FILE := hardware/qcom-caf/common/compatibility_matrix.xml
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

# HWCServices
#BOARD_USES_HWC_SERVICES := true
SKIP_DISPLAY_BLANK_CTRL := true

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(LOCAL_PATH)/include

# Legacy BLOB Support
TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
    ro.product.first_api_level=21

# Lights
TARGET_PROVIDES_LIBLIGHT := false

# Enable memfd - needed otherwise you get crashes like Jit thread pool  >>> system_server <<<
$(call soong_config_set,art,has_memfd_backport,true)

# Samsung OpenMAX Video
BOARD_USE_STOREMETADATA := true
BOARD_USE_METADATABUFFERTYPE := true
BOARD_USE_DMA_BUF := true
BOARD_USE_ANB_OUTBUF_SHARE := true
BOARD_USE_IMPROVED_BUFFER := true
BOARD_USE_NON_CACHED_GRAPHICBUFFER := true
BOARD_USE_GSC_RGB_ENCODER := true
BOARD_USE_CSC_HW := false
BOARD_USE_QOS_CTRL := false
BOARD_USE_S3D_SUPPORT := true
BOARD_USE_TIMESTAMP_REORDER_SUPPORT := false
BOARD_USE_DEINTERLACING_SUPPORT := false
BOARD_USE_VP8ENC_SUPPORT := true
BOARD_USE_HEVCDEC_SUPPORT := true
BOARD_USE_HEVCENC_SUPPORT := false
BOARD_USE_HEVC_HWIP := true
BOARD_USE_VP9DEC_SUPPORT := false
BOARD_USE_VP9ENC_SUPPORT := false
BOARD_USE_CUSTOM_COMPONENT_SUPPORT := true
BOARD_USE_VIDEO_EXT_FOR_WFD_HDCP := false
BOARD_USE_SINGLE_PLANE_IN_DRM := false

# Power
TARGET_POWERHAL_VARIANT := samsung

# Properties
TARGET_SYSTEM_PROP += $(LOCAL_PATH)/system.prop

# Recovery
BOARD_HAS_DOWNLOAD_MODE := true
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/etc/fstab.universal5433

# SELinux
#BOARD_SEPOLICY_DIRS += device/samsung/gts2-common/sepolicy
include device/lineage/sepolicy/common/sepolicy.mk
include device/lineage/sepolicy/exynos/sepolicy.mk
include device/lineage/sepolicy/libperfmgr/sepolicy.mk
include device/samsung_slsi/sepolicy/sepolicy.mk
BOARD_SEPOLICY_VERS := $(PLATFORM_SDK_VERSION).0
BOARD_VENDOR_SEPOLICY_DIRS += device/samsung/gts2-common/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/samsung/gts2-common/sepolicy/private
SELINUX_IGNORE_NEVERALLOWS := true

# Sensors
#TARGET_NO_SENSOR_PERMISSION_CHECK := true

# Shims
# libbauthserver.so used to be shimmed onto libbauthtzcommon_shim.so (a 2017
# stub whose BAuth_Hat_OP() never actually forwarded the HAT to the fingerprint
# trustlet, silently breaking enroll/auth). The real libbauthtzcommon.so is now
# present under proprietary/ and picked up by find-vendor-blobs, so link
# against it directly instead.
$(call soong_config_set,bionic,ld_shim_libs,"\
    /system/bin/mediaserver|/system/lib/libstagefright_shim.so")

# Legacy BLOB Support
$(call soong_config_set,bionic,sdk_version_overrides,"\
    /system/vendor/bin/hw/rild=27")
	
# Network Routing
TARGET_NEEDS_NETD_DIRECT_CONNECT_RULE := true	

# WFD
BOARD_USES_WFD := true

# WiFi
BOARD_HAVE_SAMSUNG_WIFI          := true
BOARD_WLAN_DEVICE                := bcmdhd
WPA_SUPPLICANT_VERSION           := VER_0_8_X
WPA_SUPPLICANT_USE_HIDL          := true
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_PARAM        := "/sys/module/dhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA          := "/vendor/etc/wifi/bcmdhd_sta.bin"
WIFI_DRIVER_FW_PATH_AP           := "/vendor/etc/wifi/bcmdhd_apsta.bin"
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
#WIFI_BAND                        := 802_11_ABG
WPA_SUPPLICANT_USE_HIDL          := true

# WiFi Configs
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:system/vendor/etc/wifi/wpa_supplicant_overlay.conf \
	$(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:system/vendor/etc/wifi/p2p_supplicant_overlay.conf

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)
