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

# Include required AOSP packges/apps/settings
# TODO: Support 32-bit arch/app (Use: core_64_bit.mk instead)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/mainline_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_minimal.mk)

# Update when configuring for Android TV, Automotive
PRODUCT_CHARACTERISTICS := tablet,nosdcard
# Update when updating to newer Android
PRODUCT_SHIPPING_API_LEVEL := 34

# Dalvik heap configuration for board which has 4GB RAM or higher
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Configure system to support APEX updates
# https://source.android.com/docs/core/ota/apex#configuring-system-support-updates
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Emulated Storage
# https://source.android.com/docs/core/storage/sdcardfs-deprecate#configuring-sdcard-replacement-functionality
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Required apps to use for booting
PRODUCT_PACKAGES += \
    Launcher3QuickStep \
    Settings \
    StorageManager \
    SystemUI \
    LatinIME \
    Provision

# Additional apps
PRODUCT_PACKAGES += \
    SettingsIntelligence \
    Gallery2 \
    Camera2 \
    Browser2 \
    QuickSearchBox
