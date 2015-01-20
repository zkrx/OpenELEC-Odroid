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

PKG_NAME="opengles-mali"
PKG_VERSION="2.0+U2"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="nonfree"
PKG_SITE="http://forum.odroid.com/viewtopic.php?f=52&t=4956"
PKG_DEPENDS_TARGET="toolchain mali-headers:host"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="OpenGL-ES and Mali driver for Mali GPUs"
PKG_LONGDESC="OpenGL-ES and Mali driver for Mali GPUs"
PKG_SOURCE_DIR="mali"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_VERSION="${PKG_VERSION}_x11"
  PKG_URL="http://builder.mdrjr.net/tools/mali-r4p0.txz"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libXfixes libXdmcp libXrender libxcb libXcomposite"
  LINKS=( "ln -sfn libMali.so libEGL.so" "ln -sfn libMali.so libGLESv2.so" )
  DESTROY=(
    "rm -rf config"
    "rm -f libEGL.so.1"
    "rm -f libEGL.so.1.4"
    "rm -f libGLESv1_CM.so"
    "rm -f libGLESv1_CM.so.1"
    "rm -f libGLESv1_CM.so.1.1"
    "rm -f libGLESv2.so.2"
    "rm -f libGLESv2.so.2.0"
  )
else
  PKG_VERSION="${PKG_VERSION}_fb"
  PKG_URL="http://builder.mdrjr.net/tools/r4p0-mp400-fbdev.tar"
  LINKS=( "ln -sfn libMali.so libEGL.so" "ln -sfn libMali.so libGLESv2.so" )
  DESTROY=(
    "rm -f libEGL.so.1"
    "rm -f libEGL.so.1.4"
    "rm -f libGLESv1_CM.so"
    "rm -f libGLESv1_CM.so.1"
    "rm -f libGLESv1_CM.so.1.1"
    "rm -f libGLESv2.so.2"
    "rm -f libGLESv2.so.2.0"
  )
fi

unpack() {
  $SCRIPTS/extract $PKG_NAME $(basename $PKG_URL) $BUILD
}

make_target() {
  for link in "${LINKS[@]}"; do
    $link
  done

  for destuct in "${DESTROY[@]}"; do
    $destuct
  done

  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PR * $SYSROOT_PREFIX/usr/lib
}

makeinstall_target() {
  for link in "${LINKS[@]}"; do
    $link
  done

  for destuct in "${DESTROY[@]}"; do
    $destuct
  done

  mkdir -p $INSTALL/usr/lib
    cp -PR * $INSTALL/usr/lib

  if [ "$DISPLAYSERVER" = "x11" ]; then
    mkdir -p $INSTALL/etc/systemd/system
      cp -PR $PKG_DIR/config/xorg.service $INSTALL/etc/systemd/system
  fi
}
