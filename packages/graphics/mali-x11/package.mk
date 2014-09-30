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

PKG_NAME="mali-x11"
PKG_VERSION="1.1"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="nonfree"
PKG_SITE="http://www.arm.com/products/multimedia/mali-graphics-hardware/mali-400-mp.php"
PKG_URL="http://zalaare.homenet.org/odroid/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libXfixes Mesa"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="mali-x11: OpenGL-ES and Mali driver for Mali GPUs (X11)"
PKG_LONGDESC="mali-x11: OpenGL-ES and Mali driver for Mali GPUs (X11)"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
 : # nothing todo
}

makeinstall_target() {
  mkdir -p $INSTALL
    cp -PR * $INSTALL
}

post_makeinstall_target() {
  rm -rf $SYSROOT_PREFIX/usr/lib/mali-4xx
  rm -rf $SYSROOT_PREFIX/usr/lib/mali-t62x
}

