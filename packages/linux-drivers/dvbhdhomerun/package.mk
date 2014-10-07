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

PKG_NAME="dvbhdhomerun"
PKG_VERSION="20130704"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://sourceforge.net/projects/dvbhdhomerun/"
PKG_URL="${DISTRO_SRC}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
#PKG_URL="$SOURCEFORGE_SRC/project/dvbhdhomerun/${PKG_NAME}_${PKG_VERSION}.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain linux libhdhomerun"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver/dvb"
PKG_SHORTDESC="A linux DVB driver for the HDHomeRun TV tuner (http://www.silicondust.com)."
PKG_LONGDESC="A linux DVB driver for the HDHomeRun TV tuner (http://www.silicondust.com)."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  cp -av $ROOT/$PKG_BUILD $ROOT/$BUILD/$PKG_NAME-odroid-u2
  cd $ROOT/$BUILD/$PKG_NAME-odroid-u2
  LDFLAGS="" make -C kernel dvb_hdhomerun KERNEL_DIR=$(odroid_u2_kernel_path)
  fix_module_depends kernel/dvb_hdhomerun_core.ko "dvb_core"

  cp -av $ROOT/$PKG_BUILD $ROOT/$BUILD/$PKG_NAME-odroid-xu3
  cd $ROOT/$BUILD/$PKG_NAME-odroid-xu3
  LDFLAGS="" make -C kernel dvb_hdhomerun KERNEL_DIR=$(odroid_xu3_kernel_path)
  fix_module_depends kernel/dvb_hdhomerun_core.ko "dvb_core"

# absolute path
  LIBHDHOMERUN_PATH=$(ls -d $ROOT/$BUILD/libhdhomerun-*/)
  sed -i "s|SET(LIBHDHOMERUN_PATH .*)|SET(LIBHDHOMERUN_PATH $LIBHDHOMERUN_PATH)|g" userhdhomerun/CMakeLists.txt
  sed -i "s|/etc/dvbhdhomerun|/tmp/dvbhdhomerun|g" userhdhomerun/hdhomerun_tuner.cpp
  sed -i "s|/etc/dvbhdhomerun|/tmp/dvbhdhomerun|g" userhdhomerun/hdhomerun_controller.cpp

  mkdir -p .$TARGET_NAME && cd .$TARGET_NAME
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DLIBHDHOMERUN_PATH=$(ls -d $ROOT/$BUILD/libhdhomerun-*/) \
        ../userhdhomerun
}

makeinstall_target() {
  cd $ROOT/$BUILD/$PKG_NAME-odroid-u2
    echo $(basename $(ls -d $(get_build_dir linux-odroid-u2)/.install_pkg/lib/modules/*))/hdhomerun
    mkdir -vp $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-u2)/.install_pkg/lib/modules/*))/hdhomerun
      cp -v kernel/*.ko $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-u2)/.install_pkg/lib/modules/*))/hdhomerun
  cd $ROOT/$BUILD/$PKG_NAME-odroid-xu3
    mkdir -vp $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-xu3)/.install_pkg/lib/modules/*))/hdhomerun
      cp -v kernel/*.ko $INSTALL/lib/modules/$(basename $(ls -d $(get_build_dir linux-odroid-xu3)/.install_pkg/lib/modules/*))/hdhomerun


    mkdir -p $INSTALL/usr/bin
      cp -PR .$TARGET_NAME/userhdhomerun $INSTALL/usr/bin
}
