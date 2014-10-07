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

PKG_NAME="sd-fuse"
PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_URL="http://zalaare.homenet.org/odroid/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain u-boot-odroid-u2 u-boot-odroid-xu3"
PKG_PRIORITY="optional"
PKG_SECTION="3rdparty"
PKG_SHORTDESC="fuse: Custom Fusing tool for Odroids"
PKG_LONGDESC="fuse: Custom script and binary blobs for Odroid U-Boot fusing"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
 : # nothing todo
}

makeinstall_target() {
  install -D -v -m 0755 sd-fuse $INSTALL/usr/bin/sd-fuse
}
