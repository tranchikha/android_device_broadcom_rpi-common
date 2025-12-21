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

.PHONY: generatedtb
.PHONY: generatedtbo

DTB_DIR := vendor/broadcom/proprietary/rpi4-kernel-prebuilt
MKDTIMG := $(abspath ./prebuilts/misc/linux-x86/libufdt/mkdtimg)
PRODUCT_OUT := $(OUT_DIR)/target/product/$(TARGET_PRODUCT)

DTB_LIST += \
	$(DTB_DIR)/bcm2711-rpi-400.dtb --id=0 \
	$(DTB_DIR)/bcm2711-rpi-4-b.dtb --id=1 \
	$(DTB_DIR)/bcm2711-rpi-cm4.dtb --id=2 \
	$(DTB_DIR)/bcm2711-rpi-cm4-io.dtb --id=3 \
	$(DTB_DIR)/bcm2711-rpi-cm4s.dtb --id=4 \
	$(DTB_DIR)/hat_map.dtb --id=5 \
	$(DTB_DIR)/overlay_map.dtb --id=6

DTBO_LIST += \
	$(DTB_DIR)/overlays/empty.dts --id=0

generatedtb:
	$(MKDTIMG) create vendor/broadcom/proprietary/rpi4-kernel-prebuilt/dtb_prebuilt.img --page_size=4096 $(DTB_LIST)
	cp -v vendor/broadcom/proprietary/rpi4-kernel-prebuilt/dtb_prebuilt.img $(PRODUCT_OUT)/dtb.img

generatedtbo:
	$(MKDTIMG) create vendor/broadcom/proprietary/rpi4-kernel-prebuilt/dtbo_prebuilt.img --page_size=4096 $(DTBO_LIST)
	cp -v vendor/broadcom/proprietary/rpi4-kernel-prebuilt/dtbo_prebuilt.img $(PRODUCT_OUT)/dtbo.img

# How to check magic
# hexdump -C vendor/broadcom/proprietary/rpi4-kernel-prebuilt/dtb_prebuilt.img | head
# Magic must start with "d0 0d fe ed" which is equaled to FDT_MAGIC
