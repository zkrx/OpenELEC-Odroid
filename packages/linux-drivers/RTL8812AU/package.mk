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

PKG_NAME="RTL8812AU"
PKG_VERSION="b22cbdf"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="git@github.com:wuzzeb/rtl8812AU_8821AU_linux.git"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Realtek RTL8812AU Linux 3.x driver"
PKG_LONGDESC="Realtek RTL8812AU Linux 3.x driver"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  find . -type f -name '*.c' -or -name '*.h' | xargs sed -i 's/\^M//g'
  if [ "$PROJECT" = Odroid ]; then
    ( mkdir .xu3 && cp -a * .xu3 )
    make -C .xu3 V=1 \
       ARCH=$TARGET_ARCH \
       KSRC=$(odroid_xu3_kernel_path) \
       CROSS_COMPILE=$TARGET_PREFIX \
       CONFIG_POWER_SAVING=n
    ( mkdir .u2 && cp -a * .u2 )
    make -C .u2 V=1 \
       ARCH=$TARGET_ARCH \
       KSRC=$(odroid_u2_kernel_path) \
       CROSS_COMPILE=$TARGET_PREFIX \
       CONFIG_POWER_SAVING=n
  else
    make V=1 \
       ARCH=$TARGET_ARCH \
       KSRC=$(kernel_path) \
       CROSS_COMPILE=$TARGET_PREFIX \
       CONFIG_POWER_SAVING=n
  fi
}

makeinstall_target() {
  if [ "$PROJECT" = Odroid ]; then
    mkdir -p $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-xu3)/.install_pkg/lib/modules/*))/$PKG_NAME
    cp .xu3/*.ko $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-xu3)/.install_pkg/lib/modules/*))/$PKG_NAME
    mkdir -p $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-u2)/.install_pkg/lib/modules/*))/$PKG_NAME
    cp .u2/*.ko $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-u2)/.install_pkg/lib/modules/*))/$PKG_NAME
  else    
    mkdir -p $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME
    cp *.ko $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME
  fi
}
