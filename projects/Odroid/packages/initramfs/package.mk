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

PKG_NAME="initramfs"
PKG_VERSION=""
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.openelec.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain libc:init busybox:init linux:init plymouth-lite:init util-linux:init e2fsprogs:init dosfstools:init"
PKG_PRIORITY="optional"
PKG_SECTION="virtual"
PKG_SHORTDESC="initramfs: Metapackage for installing initramfs"
PKG_LONGDESC="debug is a Metapackage for installing initramfs"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$ISCSI_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET open-iscsi:init"
fi

if [ "$INITRAMFS_PARTED_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET util-linux:init"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET e2fsprogs:init"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET parted:init"
fi

post_install() {
  # init
  if [ -f "$PROJECT_DIR/$PROJECT/devices/$DEVICE/initramfs/init" ]; then
    install -m 0755 $PROJECT_DIR/$PROJECT/devices/$DEVICE/initramfs/init $ROOT/$BUILD/initramfs/init
  elif [ -f "$PROJECT_DIR/$PROJECT/initramfs/init" ]; then
    case $DEVICE in
      U2)  TTY=ttySAC1 ;;
      XU3) TTY=ttySAC2 ;;
      C1)  TTY=ttyS0 ;;
    esac
    sed -e "s|tty1|$TTY|g" $PROJECT_DIR/$PROJECT/initramfs/init > $ROOT/$BUILD/initramfs/init
    chmod 0755 $ROOT/$BUILD/initramfs/init
  fi

  # platform_init
  if [ -f "$PROJECT_DIR/$PROJECT/devices/$DEVICE/initramfs/platform_init" ]; then
    install -m 0755 $PROJECT_DIR/$PROJECT/devices/$DEVICE/initramfs/platform_init $ROOT/$BUILD/initramfs/platform_init
  elif [ -f "$PROJECT_DIR/$PROJECT/initramfs/platform_init" ]; then
    install -m 0755 $PROJECT_DIR/$PROJECT/initramfs/platform_init $ROOT/$BUILD/initramfs/platform_init
  fi

  cd $ROOT/$BUILD/initramfs
    mkdir -p $ROOT/$BUILD/image/
    find . | cpio -H newc -ov -R 0:0 > $ROOT/$BUILD/image/initramfs.cpio
  cd -
}
