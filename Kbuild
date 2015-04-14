# We can build either as part of a standalone Kernel build or part
# of an Android build.  Determine which mechanism is being used
ifeq ($(MODNAME),)
	KERNEL_BUILD := 1
else
	KERNEL_BUILD := 0
endif

ifeq ($(KERNEL_BUILD),1)
	# These are provided in Android-based builds
	# Need to explicitly define for Kernel-based builds
	MODNAME := exfat
	EXFAT_ROOT := fs/exfat
endif

ifeq ($(KERNEL_BUILD), 0)
	# These are configurable via Kconfig for kernel-based builds
	# Need to explicitly configure for Android-based builds
endif

# Feature flags which are not (currently) configurable via Kconfig

# ko dep
EXFAT_OBJS := exfat_core.o exfat_super.o exfat_api.o exfat_blkdev.o exfat_cache.o \
			   exfat_data.o exfat_global.o exfat_nls.o exfat_oal.o exfat_upcase.o exfat_xattr.o

# Module information used by KBuild framework
obj-$(CONFIG_EXFAT_FS) += $(MODNAME).o
$(MODNAME)-y := $(EXFAT_OBJS)
