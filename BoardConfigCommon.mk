#
# Copyright (C) 2024 KhaTran
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

TARGET_NO_BOOTLOADER := true
# Use prebuilt kernel Image.gz and *.dtb
# TODO: Runtime build kernel support
TARGET_NO_RECOVERY := true

# TODO: prepare bluetooth firmware
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/broadcom/rpi-common

TARGET_COPY_OUT_VENDOR := vendor

######## Parititions support ########
BOARD_FLASH_BLOCK_SIZE := 4096
# Filesystem type
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true

# Partitions size - TODO: support dynamic partition
BOARD_BOOTIMAGE_PARTITION_SIZE := 134217728	# 128M
# TODO: Adjust userdata partition size
BOARD_USERDATAIMAGE_PARTITION_SIZE := 134217728	# 128M

BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_PARTITION_SIZE := 6442450944 # 6GB
BOARD_SUPER_PARTITION_GROUPS := krpi_partitions
# Size of BOARD_KRPI_PARTITIONS_SIZE must less than BOARD_SUPER_PARTITION_SIZE / 2
BOARD_KRPI_PARTITIONS_SIZE := 3204448256 # 3GB - 16MB = 3056MB. Reserve 16MB for metadata
BOARD_KRPI_PARTITIONS_PARTITION_LIST := system vendor

# ext4 images can be further compressed by enabling block- level deduplication
BOARD_EXT4_SHARE_DUP_BLOCKS := true

# We don't support fastboot flashing now.
# So sparse image is not needed now.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

######## End of Parititions support ########

######## Project Treble support ########

PRODUCT_FULL_TREBLE_OVERRIDE := true
# Properties that are set by PRODUCT_PROPERTY_OVERRIDES will be copied
# to /vendor/build.prop
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_VNDK_VERSION                     := current
######## End of Project Treble support ########

# Kernel command line for booting. It will be appended to cmdline.txt
BOARD_KERNEL_CMDLINE += console=ttyS0,115200 root=/dev/ram0 rootwait
# Use for loading fstab (fstab.${ro.boot.hardware}) and load *.so HALs and other similar purposes
BOARD_KERNEL_CMDLINE += androidboot.hardware=$(TARGET_PRODUCT)
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_CMDLINE += androidboot.serialno=RAndroid
BOARD_KERNEL_CMDLINE += firmware_class.path=/vendor/etc/firmware
BOARD_KERNEL_CMDLINE += loglevel=0
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=emmc2bus/fe340000.mmc

# Vendor Interface Manifest
DEVICE_MANIFEST_FILE                        := device/broadcom/rpi-common/manifest/manifest.xml
DEVICE_MATRIX_FILE                          := device/broadcom/rpi-common/manifest/compatibility_matrix.xml

# SELinux support
BOARD_VENDOR_SEPOLICY_DIRS       += device/broadcom/rpi-common/sepolicy/vendor

# Overlay
DEVICE_PACKAGE_OVERLAYS                     := device/broadcom/rpi-common/overlay

# Adding properties to vendor.prop to have own properties
# and have a chance to support Android GSI which overrides properties
# in system partition.
TARGET_VENDOR_PROP += device/broadcom/rpi-common/vendor.prop

# Bluetooth properties should be added separately
# TODO: Configure different bluetooth properties for Android Automotive/Car
TARGET_VENDOR_PROP += device/broadcom/rpi-common/bluetooth.prop

# Wi-Fi
BOARD_WLAN_DEVICE           := bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
# From hardware/broadcom/wlan
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WPA_SUPPLICANT_VERSION      := VER_0_8_X
WIFI_DRIVER_MODULE_NAME     := $(BOARD_WLAN_DEVICE)
