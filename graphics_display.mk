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

# Mesa graphics configuration from external/mesa3d
BOARD_MESA3D_USES_MESON_BUILD := true
BOARD_MESA3D_GALLIUM_DRIVERS := vc4 v3d
BOARD_MESA3D_BUILD_LIBGBM := true
BOARD_MESA3D_VULKAN_DRIVERS := broadcom
# Enable Vulkan backend for SKIA/HWUI
#TARGET_USES_VULKAN = true

PRODUCT_PACKAGES += \
    libEGL_mesa \
    libGLESv1_CM_mesa \
    libGLESv2_mesa \
    libgallium_dri \
    libglapi

# Vulkan
PRODUCT_PACKAGES += \
    vulkan.broadcom

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-service.minigbm_gbm_mesa \
    mapper.minigbm_gbm_mesa

PRODUCT_PACKAGES += \
    dri_gbm \
    libgbm_mesa

# hwcomposer3 - display HAL
PRODUCT_PACKAGES += \
    android.hardware.composer.hwc3-service.drm
