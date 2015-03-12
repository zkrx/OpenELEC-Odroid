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

PKG_NAME="odroidu2-fan-service"
PKG_VERSION="1.0.8"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="other"
PKG_URL="https://github.com/nfstry/odroidu2-fan-service/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME-$PKG_NAME-$PKG_VERSION"
PKG_HOST_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="Fancontrol Service for Odroid"
PKG_LONGDESC="enables control of the fan for odroid"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

makeinstall_target() {
  install -D -m 0644 ubuntu_service/fancontrol.service $INSTALL/usr/lib/systemd/system/fancontrol.service
  install -D -m 0755 odroidu2-fan $INSTALL/bin/odroidu2-fan

  enable_service fancontrol.service
}
