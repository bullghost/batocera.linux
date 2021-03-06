################################################################################
#
# mupen64plus rsp-hle
#
################################################################################

MUPEN64PLUS_RSPHLE_VERSION = multiple

ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_C2)$(BR2_PACKAGE_RECALBOX_TARGET_XU4)$(BR2_PACKAGE_RECALBOX_TARGET_X86)$(BR2_PACKAGE_RECALBOX_TARGET_X86_64),y)
	MUPEN64PLUS_RSPHLE_VERSION = cd9ffb7eb43bd3057f2fa58ff6268a1be9851107
	MUPEN64PLUS_RSPHLE_SITE = $(call github,mupen64plus,mupen64plus-rsp-hle,$(MUPEN64PLUS_RSPHLE_VERSION))
else
	MUPEN64PLUS_RSPHLE_VERSION = 5d66105bda2acdfc81a3698b025c99326552146f
	MUPEN64PLUS_RSPHLE_SITE = $(call github,ricrpi,mupen64plus-rsp-hle,$(MUPEN64PLUS_RSPHLE_VERSION))
endif

MUPEN64PLUS_RSPHLE_LICENSE = MIT
MUPEN64PLUS_RSPHLE_DEPENDENCIES = sdl2 alsa-lib mupen64plus-core
MUPEN64PLUS_RSPHLE_INSTALL_STAGING = YES


define MUPEN64PLUS_RSPHLE_BUILD_CMDS
        CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
        $(MAKE)  CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
	PREFIX="$(STAGING_DIR)/usr" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
        APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
	GL_CFLAGS="$(MUPEN64PLUS_GL_CFLAGS)" \
	GL_LDLIBS="$(MUPEN64PLUS_GL_LDLIBS)" \
	-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)" 
endef

define MUPEN64PLUS_RSPHLE_INSTALL_TARGET_CMDS
        CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
        $(MAKE)  CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
	PREFIX="$(TARGET_DIR)/usr/" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
        APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
	GL_CFLAGS="$(MUPEN64PLUS_GL_CFLAGS)" \
	GL_LDLIBS="$(MUPEN64PLUS_GL_LDLIBS)" \
	INSTALL="/usr/bin/install" \
	INSTALL_STRIP_FLAG="" \
	-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)" install
endef

define MUPEN64PLUS_RSPHLE_CROSS_FIXUP
        $(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/projects/unix/Makefile
        $(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/projects/unix/Makefile
endef

MUPEN64PLUS_RSPHLE_PRE_CONFIGURE_HOOKS += MUPEN64PLUS_RSPHLE_CROSS_FIXUP

$(eval $(generic-package))
