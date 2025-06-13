# 
#  Copyright (C) 2024 KhaTran
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

include $(all-subdir-makefiles)

PRODUCT_COPY_FILES += \
    device/broadcom/rpi-common/fstab.zram:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.zram.$(TARGET_PRODUCT) \
    device/broadcom/rpi-common/fstab:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(TARGET_PRODUCT) \
    device/broadcom/rpi-common/fstab:$(TARGET_COPY_OUT_RAMDISK)/fstab.$(TARGET_PRODUCT)

# Add common init rc file
# TODO: Support USB init rc file
PRODUCT_COPY_FILES += \
    device/broadcom/rpi-common/init/init.rpi.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(TARGET_PRODUCT).rc \
    device/broadcom/rpi-common/init/ueventd.rpi-common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    device/broadcom/rpi-common/init/init.rpi.common.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(TARGET_PRODUCT).usb.rc

# Project Treble support
PRODUCT_PACKAGES += vndk_package

# Support generic HALs
include device/broadcom/rpi-common/hal_generic.mk

# Add Android permissions
include device/broadcom/rpi-common/permission.mk

# Support Graphics and Display HAL
include device/broadcom/rpi-common/graphics_display.mk

# Handle camera support
include device/broadcom/rpi-common/camera.mk

# Generic Keylayout
PRODUCT_COPY_FILES += \
    device/broadcom/rpi-common/Generic.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl

# Kernel
PRODUCT_COPY_FILES += \
    vendor/broadcom/proprietary/rpi4-kernel-prebuilt/Image:$(PRODUCT_OUT)/kernel

# Custom PHONY to create boot.img
include device/broadcom/rpi-common/preparebootimg.mk

# Support usbgadget HAL
include device/broadcom/rpi-common/usb.mk

# Support bluetooth HAL
include device/broadcom/rpi-common/bluetooth.mk

# Support audio HAL
include device/broadcom/rpi-common/audio.mk

# Wi-Fi
include device/broadcom/rpi-common/wifi.mk

# codec
# Initial support: software level
include device/broadcom/rpi-common/codec.mk

# GMS
include vendor/partner_gms/products/gms.mk
