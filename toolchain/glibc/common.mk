#
# Copyright (C) 2006-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=glibc
PKG_VERSION:=2.38
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=6a52d5cab01ee8d3303f7c0939d6b2618c8a9606
PKG_MIRROR_HASH:=2f55c40271e064e4fa338d9a04fd258c4c59a6ad198ab4bbfb7782e318db80c2
PKG_SOURCE_URL:=https://sourceware.org/git/glibc.git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.zst
PKG_CPE_ID:=cpe:/a:gnu:glibc

HOST_BUILD_DIR:=$(BUILD_DIR_TOOLCHAIN)/$(PKG_SOURCE_SUBDIR)
CUR_BUILD_DIR:=$(HOST_BUILD_DIR)-$(VARIANT)
PATCH_DIR:=$(PATH_PREFIX)/patches

include $(INCLUDE_DIR)/toolchain-build.mk

HOST_STAMP_PREPARED:=$(HOST_BUILD_DIR)/.prepared
HOST_STAMP_CONFIGURED:=$(CUR_BUILD_DIR)/.configured
HOST_STAMP_BUILT:=$(CUR_BUILD_DIR)/.built
HOST_STAMP_INSTALLED:=$(TOOLCHAIN_DIR)/stamp/.glibc_$(VARIANT)_installed

ifeq ($(ARCH),mips64)
  ifdef CONFIG_MIPS64_ABI_N64
    TARGET_CFLAGS += -mabi=64
  endif
  ifdef CONFIG_MIPS64_ABI_N32
    TARGET_CFLAGS += -mabi=n32
  endif
  ifdef CONFIG_MIPS64_ABI_O32
    TARGET_CFLAGS += -mabi=32
  endif
endif

# -Os miscompiles w. 2.24 gcc5/gcc6
# only -O2 tested by upstream changeset
# "Optimize i386 syscall inlining for GCC 5"
GLIBC_CONFIGURE:= \
	unset LD_LIBRARY_PATH; \
	BUILD_CC="$(HOSTCC)" \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="-O2 $(filter-out -Os,$(call qstrip,$(TARGET_CFLAGS)))" \
	libc_cv_slibdir="/lib" \
	use_ldconfig=no \
	$(HOST_BUILD_DIR)/$(GLIBC_PATH)configure \
		--prefix= \
		--build=$(GNU_HOST_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
		--with-headers=$(TOOLCHAIN_DIR)/include \
		--disable-profile \
		--disable-werror \
		--without-gd \
		--without-cvs \
		--enable-add-ons \
		--enable-crypt \
		--$(if $(CONFIG_SOFT_FLOAT),without,with)-fp \
		  $(if $(CONFIG_PKG_CC_STACKPROTECTOR_REGULAR),--enable-stack-protector=yes) \
		  $(if $(CONFIG_PKG_CC_STACKPROTECTOR_STRONG),--enable-stack-protector=strong) \
		  $(if $(CONFIG_PKG_CC_STACKPROTECTOR_ALL),--enable-stack-protector=all) \
		  $(if $(CONFIG_PKG_RELRO_FULL),--enable-bind-now) \
		  $(if $(CONFIG_PKG_FORTIFY_SOURCE_1),--enable-fortify-source=1) \
		  $(if $(CONFIG_PKG_FORTIFY_SOURCE_2),--enable-fortify-source=2) \
		--enable-kernel=5.15.0

export libc_cv_ssp=no
export libc_cv_ssp_strong=no
export ac_cv_header_cpuid_h=yes
export HOST_CFLAGS := $(HOST_CFLAGS) -idirafter $(CURDIR)/$(PATH_PREFIX)/include

define Host/SetToolchainInfo
	$(SED) 's,^\(LIBC_TYPE\)=.*,\1=$(PKG_NAME),' $(TOOLCHAIN_DIR)/info.mk
	$(SED) 's,^\(LIBC_URL\)=.*,\1=http://www.gnu.org/software/libc/,' $(TOOLCHAIN_DIR)/info.mk
	$(SED) 's,^\(LIBC_VERSION\)=.*,\1=$(PKG_VERSION),' $(TOOLCHAIN_DIR)/info.mk
	$(SED) 's,^\(LIBC_SO_VERSION\)=.*,\1=$(PKG_VERSION),' $(TOOLCHAIN_DIR)/info.mk
endef

define Host/Configure
	mkdir -p $(CUR_BUILD_DIR)
	( cd $(CUR_BUILD_DIR); rm -f config.cache; \
		$(GLIBC_CONFIGURE) \
	);
endef

define Host/Prepare
	$(call Host/Prepare/Default)
	ln -snf $(PKG_SOURCE_SUBDIR) $(BUILD_DIR_TOOLCHAIN)/$(PKG_NAME)
endef

define Host/Clean
	rm -rf $(CUR_BUILD_DIR)* \
		$(BUILD_DIR_TOOLCHAIN)/$(LIBC)-dev \
		$(BUILD_DIR_TOOLCHAIN)/$(PKG_NAME)
endef
