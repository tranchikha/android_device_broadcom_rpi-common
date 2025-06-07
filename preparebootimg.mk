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

VENDOR_PATH := vendor/broadcom/proprietary

.PHONY: preparerpibootimg
.PHONY: creatbootimg

preparerpibootimg: ramdisk
	@echo "Preparing data for boot image"
	@mkdir -p $(PRODUCT_OUT)/boot/overlays
	@cp $(VENDOR_PATH)/$(TARGET_PRODUCT)-kernel-prebuilt/Image $(PRODUCT_OUT)/boot
	@cp $(VENDOR_PATH)/$(TARGET_PRODUCT)-kernel-prebuilt/*.dtb $(PRODUCT_OUT)/boot
	@cp $(VENDOR_PATH)/$(TARGET_PRODUCT)-kernel-prebuilt/overlays/* $(PRODUCT_OUT)/boot/overlays
	@cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/boot
	@cp $(VENDOR_PATH)/$(TARGET_PRODUCT)/boot/* $(PRODUCT_OUT)/boot
	@echo $(BOARD_KERNEL_CMDLINE) > $(PRODUCT_OUT)/boot/cmdline.txt

creatbootimg: preparerpibootimg
	$(call pretty,"Target boot image: $(PRODUCT_OUT)/boot.img")
	@dd if=/dev/zero of=$(PRODUCT_OUT)/boot.img bs=1M count=128
	@mkfs.fat $(PRODUCT_OUT)/boot.img -F 32 -n "bootimg"
	@mcopy -s -i $(PRODUCT_OUT)/boot.img $(PRODUCT_OUT)/boot/* -spQm ::/
