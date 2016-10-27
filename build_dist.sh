#!/bin/bash
set -e
PKG=wafflepkg/wafflepkg-*.pkg.tar.xz
if [ "$(ls $PKG | wc -l)" != "1" ]
then
	echo "Bad count"
	exit 1
fi
cp $PKG $(basename $PKG)
mkdir -p dist
GEN=dist/waffleiron-$(date +%F_%H-%M-%S%z).tar.gz
tar -czf $GEN init_disks.sh init_inside.sh mirrorlist syslinux.cfg.default $(basename $PKG)
rm $(basename $PKG)
sha256sum $GEN
gpg --sign $GEN
