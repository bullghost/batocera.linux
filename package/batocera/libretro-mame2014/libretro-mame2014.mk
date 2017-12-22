################################################################################
#
# MAME2014
#
################################################################################
LIBRETRO_MAME2014_VERSION = 8cd09f43f397c8220cd2dc69a0db1eb12030dc19
LIBRETRO_MAME2014_SITE = $(call github,libretro,mame2014-libretro,$(LIBRETRO_MAME2014_VERSION))

SUPP_OPT=

ifeq ($(BR2_x86_64),y)
	SUPP_OPT=ARCH=x86_64
endif

ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_XU4),y)
       LIBRETRO_PLATFORM += odroid
endif

define LIBRETRO_MAME2014_BUILD_CMDS
	mkdir -p $(@D)/obj/mame/cpu/ccpu
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CC="$(TARGET_CC) -lm -Wcast-align " CXX="${TARGET_CC} -lm -Wcast-align " LD="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)" $(SUPP_OPT) emulator

endef

define LIBRETRO_MAME2014_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mame2014_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/mame2014_libretro.so
endef

$(eval $(generic-package))
