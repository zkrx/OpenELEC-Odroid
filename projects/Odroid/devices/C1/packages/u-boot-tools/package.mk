################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="u-boot-tools"
PKG_VERSION="2015.01"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="other"
PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
PKG_URL="ftp://ftp.denx.de/pub/u-boot/u-boot-$PKG_VERSION.tar.bz2"
PKG_HOST_DEPENDS_TARGET="toolchain libressl:host"
PKG_DEPENDS_TARGET="toolchain libressl"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="A few tools for U-Boot"
PKG_LONGDESC="A few tools for U-Boot"
PKG_SOURCE_DIR="u-boot-$PKG_VERSION"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  $SCRIPTS/extract $PKG_NAME $(basename $PKG_URL) $BUILD
}

configure_host() {
  : # nothing to do
}

configure_target() {
  : # nothing to do
}

make_target() {
  make defconfig
#  make tools-all
  make V=1 CROSS_COMPILE="arm-none-eabi-" HOSTCC="$HOST_CC" HOSTSTRIP="true" -C tools mkimage
}

make_host() {
  make defconfig
  make tools-all
}

makeinstall_host() {
  mkdir -p $SYSROOT_PREFIX/usr/bin
    install -m 0755 tools/mkimage $SYSROOT_PREFIX/usr/bin/mkimage
    install -m 0755 tools/mkenvimage $SYSROOT_PREFIX/usr/bin/mkenvimage
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    install -m 0755 tools/mkimage $INSTALL/usr/bin/mkimage
    install -m 0755 tools/mkenvimage $INSTALL/usr/bin/mkenvimage
    install -m 0755 tools/env/fw_printenv $INSTALL/usr/bin/fw_printenv
    ln -s fw_printenv $INSTALL/usr/bin/fw_setenv
}
