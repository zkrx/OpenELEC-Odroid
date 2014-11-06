#!/bin/sh

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

case $(cat /proc/cpuinfo | grep ^Hardware | awk -F : '{print $2}' | sed 's, ,,') in
   ODROID-U2*) ODROID=U2 ;;
   ODROID-XU3) ODROID=XU3 ;;
esac

[ -z "$BOOT_ROOT" ] && BOOT_ROOT="/flash"
[ -z "$DEVICE" ] && DEVICE=$(df "$BOOT_ROOT" | tail -1 | awk {' print $1 '} | sed 's,p[0-9],,')
[ -z "$SYSTEM_ROOT" ] && SYSTEM_ROOT=""

echo "*** updating u-boot for $ODROID on: $DEVICE ..."

case $ODROID in
  U2)
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/U2/bl1 of=$DEVICE seek=1
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/U2/bl2 of=$DEVICE seek=31
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/U2/u-boot of=$DEVICE seek=63
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/U2/tzsw of=$DEVICE seek=2111
    ;;
  XU3)
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/XU3/bl1 of=$DEVICE seek=1
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/XU3/bl2 of=$DEVICE seek=31
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/XU3/u-boot of=$DEVICE seek=63
    dd bs=512 if=$SYSTEM_ROOT/usr/share/bootloader/XU3/tzsw of=$DEVICE seek=719
    ;;
esac
