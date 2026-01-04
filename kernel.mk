# Android makefile to build kernel as a part of Android build

$(warning "KHATRAN KERNEL DEBUGGING 1")
#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)
#-------------------------------------------------------------------------------
ifeq ($(TARGET_PREBUILT_KERNEL),)
$(warning "KHATRAN KERNEL DEBUGGING 2 PRODUCT_OUT is $(PRODUCT_OUT)")

PRODUCT_BOARD_PLATFORM ?= broadcom

#-------------------------------------------------------------------------------
ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
KERNEL_SRC		?= glodroid/kernel/stable
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),rockchip)
KERNEL_SRC		?= glodroid/kernel/stable
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),broadcom)
KERNEL_SRC		?= glodroid/kernel/broadcom
endif

KERNEL_SRC       := glodroid/kernel/broadcom
KERNEL_DEFCONFIG := $(KERNEL_SRC)/arch/arm64/configs/android_rpi4_defconfig

KERNEL_FRAGMENTS := \
    $(LOCAL_PATH)/kernel.config \

$(warning "LOCAL_PATH is $(LOCAL_PATH) CLANG is $(CLANG), target arch is $(TARGET_ARCH)")

TRIPLE=aarch64-linux-gnu
CROSS_COMPILE := prebuilts/gcc/linux-x86/aarch64/gcc-linaro-$(TRIPLE)/bin/$(TRIPLE)-
AOSP_TOP_ABS := $(realpath .)

CLANG_ABS := $(abspath $(AOSP_TOP_ABS)/$(CLANG))
LLD_ABS := $(abspath $(AOSP_TOP_ABS)/$(LLVM_PREBUILTS_PATH)/ld.lld)

MAKE_COMMON := \
    PATH=/usr/bin:/bin:/sbin:$$PATH \
    ARCH=$(TARGET_ARCH) \
    CROSS_COMPILE=$(AOSP_TOP_ABS)/$(CROSS_COMPILE) \
    $(MAKE)

ifeq ($(BUILD_KERNEL_USING_GCC),)
MAKE_COMMON_CLANG := CC=$(CLANG_ABS) HOSTCC=$(CLANG_ABS) LD=$(LLD_ABS)
endif

KERNEL_DTB_FILE := broadcom/bcm2711-rpi-4-b.dtb

KERNEL_FRAGMENTS	:= \
    $(LOCAL_PATH)/android-base.config \
    $(LOCAL_PATH)/android-recommended.config \
    $(LOCAL_PATH)/android-extra.config \
    $(KERNEL_FRAGMENTS)

ifeq ($(TARGET_ARCH),arm64)
KERNEL_FRAGMENTS	+= \
    $(LOCAL_PATH)/android-recommended-arm64.config \
    $(LOCAL_PATH)/android-extra-arm64.config
else
KERNEL_FRAGMENTS	+= \
    $(LOCAL_PATH)/android-recommended-arm.config \
    $(LOCAL_PATH)/android-extra-arm.config
endif

KERNEL_OUT		:= $(PRODUCT_OUT)/obj/KERNEL_OBJ
KERNEL_OUT_ABS		:= $(abspath $(KERNEL_OUT))
KERNEL_MODULES_OUT 	:= $(PRODUCT_OUT)/obj/KERNEL_MODULES
KERNEL_VERSION_FILE     := $(KERNEL_OUT)/include/config/kernel.release
TARGET_VENDOR_MODULES   := $(TARGET_OUT_VENDOR_DLKM)/lib/modules

KERNEL_BOOT_DIR		:= arch/$(TARGET_ARCH)/boot
ifeq ($(TARGET_ARCH),arm64)
KERNEL_TARGET		:= Image
else
KERNEL_TARGET		:= zImage
endif
KERNEL_BINARY		:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/$(KERNEL_TARGET)
KERNEL_COMPRESSED	:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/Image.lz4
ifeq ($(TARGET_ARCH),arm64)
KERNEL_IMAGE		:= $(KERNEL_COMPRESSED)
else
KERNEL_IMAGE		:= $(KERNEL_BINARY)
endif
KERNEL_DTS_DIR		:= $(KERNEL_BOOT_DIR)/dts
KERNEL_DTB_OUT		:= $(KERNEL_OUT)/$(KERNEL_DTS_DIR)
ANDROID_DTS_OVERLAY	?= $(LOCAL_PATH)/empty.dts
ANDROID_DTBO		:= $(KERNEL_DTB_OUT)/fstab-android-sdcard.dtbo
BOARD_PREBUILT_DTBOIMAGE := $(PRODUCT_OUT)/boot_dtbo.img
#MKDTBOIMG		:= $(HOST_OUT_EXECUTABLES)/mkdtboimg.py
MKDTBOIMG		:= $(HOST_OUT_EXECUTABLES)/mkdtboimg

GEN_DTBCFG		:= $(PRODUCT_OUT)/gen/DTBO/dtbo.cfg

KERNEL_SRC_FILES        := $(sort $(shell find -L $(KERNEL_SRC) -not -path '*/\.git/*'))
#$(warning "KERNEL_SRC_FILES is $(KERNEL_SRC_FILES)")

# DEPENDING on $(KERNEL_SRC_FILES) caused issue "depends on PHONY target "13""

KMAKE := \
    $(MAKE_COMMON) $(MAKE_COMMON_CLANG) \
    -C $(KERNEL_SRC) O=$(AOSP_TOP_ABS)/$(KERNEL_OUT) \
    DTC_FLAGS='--symbols' \

#-------------------------------------------------------------------------------
#$(KERNEL_OUT)/.config: $(KERNEL_DEFCONFIG) $(KERNEL_FRAGMENTS) $(KERNEL_SRC_FILES)
#$(KERNEL_OUT)/.config: $(KERNEL_DEFCONFIG) $(KERNEL_SRC_FILES)
$(KERNEL_OUT)/.config: $(KERNEL_DEFCONFIG)
	echo "DEBUGG KHA00000"
	#cp $(KERNEL_DEFCONFIG) $(KERNEL_OUT)/.config
	$(KMAKE) android_rpi4_defconfig
	#$(KMAKE) olddefconfig -j1
	echo "DEBUGG KHA11111"
	#PATH=/usr/bin:/bin:$$PATH $(KERNEL_SRC)/scripts/kconfig/merge_config.sh -m -O $(KERNEL_OUT_ABS)/ $(KERNEL_OUT_ABS)/.config $(KERNEL_FRAGMENTS)
	echo "DEBUGG KHA1222222222222222222222"
	#$(KMAKE) olddefconfig -j1

#$(KERNEL_BINARY): $(KERNEL_SRC_FILES) $(KERNEL_OUT)/.config
$(KERNEL_BINARY): $(KERNEL_OUT)/.config
	echo "DEBUG KHAAAAAAAAAAA"
	$(KMAKE) $(KERNEL_TARGET) dtbs modules -j1
	echo "DEBUG KHAAAAAAAAAAABBBBBBBBBBBBBBB"
	touch $@
	echo "DEBUG KHAAAAAAAAAAABBBBBBBBBBBBBBBCCCCCCCCCCCCCC"

$(KERNEL_COMPRESSED): $(KERNEL_BINARY)
	rm -f $@
	PATH=/usr/bin:/bin:/sbin:$$PATH lz4c -c1 $< $@
	touch $@

# Modules

$(KERNEL_MODULES_OUT): $(KERNEL_BINARY)
	rm -rf $@
	$(KMAKE) INSTALL_MOD_PATH=$(AOSP_TOP_ABS)/$@ modules_install -j1

$(TARGET_VENDOR_MODULES)/modules.dep : $(KERNEL_MODULES_OUT)
	rm -rf $(TARGET_VENDOR_MODULES)/kernel
	rm -f $(TARGET_VENDOR_MODULES)/modules.*
	mkdir -p $(TARGET_VENDOR_MODULES)
	D1=$</lib/modules/$$(cat $(KERNEL_VERSION_FILE)); \
	    cp -r $${D1}/modules.dep $${D1}/modules.order $${D1}/modules.alias $${D1}/kernel $(TARGET_VENDOR_MODULES)
	D2=/vendor_dlkm/lib/modules/kernel/; sed -e"s|^kernel/|$${D2}|; s| kernel/| $${D2}|g" -i $(TARGET_VENDOR_MODULES)/modules.dep

$(PRODUCT_OUT)/vendor_dlkm.img: $(TARGET_VENDOR_MODULES)/modules.dep

#-------------------------------------------------------------------------------
$(ANDROID_DTBO): $(ANDROID_DTS_OVERLAY)
	rm -f $@
	./prebuilts/misc/linux-x86/dtc/dtc -@ -I dts -O dtb -o $@ $<

$(GEN_DTBCFG):
	mkdir -p $(dir $@)
	echo "# DTBO image configuration file for GloDroid project. Autogenerated, do not change!" > $@
	echo "  page_size=4096" >> $@
ifeq ($(PRODUCT_DEVICE),pinephone)
	echo "$(AOSP_TOP_ABS)/$(KERNEL_DTB_OUT)/$(KERNEL_DTB_FILE_PP11)" >> $@
	echo "  id=0x00000011" >> $@
	echo "$(AOSP_TOP_ABS)/$(KERNEL_DTB_OUT)/$(KERNEL_DTB_FILE_PP12)" >> $@
	echo "  id=0x00000012" >> $@
else
	echo "$(AOSP_TOP_ABS)/$(KERNEL_DTB_OUT)/$(KERNEL_DTB_FILE)" >> $@
	echo "  id=0x00000100" >> $@
endif
	echo "$(AOSP_TOP_ABS)/$(ANDROID_DTBO)" >> $@
	echo "  id=0x00000FFF" >> $@

$(BOARD_PREBUILT_DTBOIMAGE): $(GEN_DTBCFG) $(ANDROID_DTBO) $(KERNEL_BINARY) $(MKDTBOIMG)
	$(call pretty,"Target dtb image: $@")
	$(MKDTBOIMG) cfg_create $@ $<

#-------------------------------------------------------------------------------
$(PRODUCT_OUT)/kernel: $(KERNEL_IMAGE) $(KERNEL_MODULES_OUT)
	cp -v $< $@

#-------------------------------------------------------------------------------

#include $(LOCAL_PATH)/rtl8189es-mod.mk
#include $(LOCAL_PATH)/rtl8189fs-mod.mk

endif # TARGET_PREBUILT_KERNEL
