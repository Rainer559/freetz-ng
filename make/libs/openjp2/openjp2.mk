$(call PKG_INIT_LIB, a5891555eb49ed7cc26b2901ea680acda136d811)
$(PKG)_LIB_VERSION:=2.5.0
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=eb777df08834b9d0293763077581709c8fb38ab0e253c74e9f9b33bc45ec324c
$(PKG)_SITE:=git@https://github.com/uclouvain/openjpeg.git
### VERSION:=2.5.0
### WEBSITE:=https://www.openjpeg.org/
### MANPAGE:=https://github.com/uclouvain/openjpeg/wiki
### CHANGES:=https://github.com/uclouvain/openjpeg/blob/master/NEWS.md
### CVSREPO:=https://github.com/uclouvain/openjpeg

$(PKG)_LIBNAME:=libopenjp2.so.$($(PKG)_LIB_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/bin/$($(PKG)_LIBNAME)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$($(PKG)_LIBNAME)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$($(PKG)_LIBNAME)

$(PKG)_CONFIGURE_OPTIONS += -DCMAKE_INSTALL_PREFIX="/"
$(PKG)_CONFIGURE_OPTIONS += -DCMAKE_SKIP_INSTALL_RPATH=NO
$(PKG)_CONFIGURE_OPTIONS += -DCMAKE_SKIP_RPATH=NO

$(PKG)_CONFIGURE_OPTIONS += -DBUILD_SHARED_LIBS=ON
$(PKG)_CONFIGURE_OPTIONS += -DBUILD_STATIC_LIBS=ON

$(PKG)_CONFIGURE_OPTIONS += -DBUILD_DOC=OFF
$(PKG)_CONFIGURE_OPTIONS += -DBUILD_JAVA=OFF
$(PKG)_CONFIGURE_OPTIONS += -DBUILD_JPIP=OFF
$(PKG)_CONFIGURE_OPTIONS += -DBUILD_LUTS_GENERATOR=OFF
$(PKG)_CONFIGURE_OPTIONS += -DBUILD_TESTING=OFF
$(PKG)_CONFIGURE_OPTIONS += -DBUILD_THIRDPARTY=OFF
$(PKG)_CONFIGURE_OPTIONS += -DBUILD_UNIT_TESTS=OFF

$(PKG)_CONFIGURE_OPTIONS += -DLCMS_INCLUDE_DIR=""
$(PKG)_CONFIGURE_OPTIONS += -DLCMS2_INCLUDE_DIR=""
$(PKG)_CONFIGURE_OPTIONS += -DTIFF_INCLUDE_DIR=""
$(PKG)_CONFIGURE_OPTIONS += -DZLIB_INCLUDE_DIR=""
$(PKG)_CONFIGURE_OPTIONS += -DPNG_INCLUDE_DIR=""
$(PKG)_CONFIGURE_OPTIONS += -DPNG_PNG_INCLUDE_DIR=""


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CMAKE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(OPENJP2_DIR)
#cmake	cd $(GETDNS_DIR) && cmake -LA .

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(OPENJP2_DIR) \
		DESTDIR=$(TARGET_TOOLCHAIN_STAGING_DIR) \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/libopenjp2.pc
	@touch $@

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(OPENJP2_DIR) clean
	$(RM) -r \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/openjpeg-2.5/ \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/openjpeg-2.5/ \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/libopenjp2.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libopenjp2.*

$(pkg)-uninstall:
	$(RM) $(OPENJP2_TARGET_DIR)/libopenjp2.so*

$(PKG_FINISH)
