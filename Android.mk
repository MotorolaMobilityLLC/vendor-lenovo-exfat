# Android makefile for the EXFAT Module, lenovo MACRO control begin
ifeq ($(LENOVO_EXFAT),true)
# Assume no targets will be supported

# Build/Package options for lenovo target
EXFAT_CODESET := lenovo
EXFAT_SELECT := CONFIG_EXFAT_FS=m

# Build/Package only in case of supported target
ifneq ($(EXFAT_CODESET),)

LOCAL_PATH := $(call my-dir)

# This makefile is only for DLKM
ifneq ($(findstring vendor,$(LOCAL_PATH)),)

# Determine if we are Proprietary or Open Source
ifneq ($(findstring lenovo,$(LOCAL_PATH)),)
    EXFAT_PROPRIETARY := 0
else
    EXFAT_PROPRIETARY := 1
endif

ifeq ($(EXFAT_PROPRIETARY),1)
    EXFAT_BLD_DIR := vendor/gpl/exfat
else
    EXFAT_BLD_DIR := vendor/lenovo/exfat
endif

# DLKM_DIR was moved for JELLY_BEAN (PLATFORM_SDK 16)
ifeq (1,$(filter 1,$(shell echo "$$(( $(PLATFORM_SDK_VERSION) >= 16 ))" )))
#       DLKM_DIR := $(TOP)/device/qcom/common/dlkm
       DLKM_DIR := $(TOP)/vendor/lenovo/exfat
else
       DLKM_DIR := build/dlkm
endif


# Build exfat.ko as lenovo_exfat.ko
###########################################################

# This is set once per LOCAL_PATH, not per (kernel) module
KBUILD_OPTIONS := EXFAT_ROOT=../$(EXFAT_BLD_DIR)
# We are actually building exfat.ko here, as per the
# requirement we are specifying <chipset>_exfat.ko as LOCAL_MODULE.
# This means we need to rename the module to <chipset>_exfat.ko
# after exfat.ko is built.
KBUILD_OPTIONS += MODNAME=exfat
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)
KBUILD_OPTIONS += $(EXFAT_SELECT)


VERSION=$(shell grep -w "VERSION =" $(TOP)/kernel/Makefile | sed 's/^VERSION = //' )
PATCHLEVEL=$(shell grep -w "PATCHLEVEL =" $(TOP)/kernel/Makefile | sed 's/^PATCHLEVEL = //' )

include $(CLEAR_VARS)
LOCAL_MODULE              := $(EXFAT_CODESET)_exfat.ko
LOCAL_MODULE_KBUILD_NAME  := exfat.ko
LOCAL_MODULE_TAGS         := optional eng debug
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(TARGET_OUT)/lib/modules/$(EXFAT_CODESET)
include $(DLKM_DIR)/AndroidKernelModule.mk
###########################################################

#Create symbolic link
$(shell mkdir -p $(TARGET_OUT)/lib/modules; \
        ln -sf /system/lib/modules/$(EXFAT_CODESET)/$(EXFAT_CODESET)_exfat.ko \
               $(TARGET_OUT)/lib/modules/exfat.ko)

endif # DLKM check

endif # supported target check

endif # Android makefile for the EXFAT Module, lenovo MACRO control end
