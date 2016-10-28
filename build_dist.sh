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
rm -f dist/*
GEN=dist/waffles.tgz
tar -czf $GEN init_disks.sh init_inside.sh mirrorlist syslinux.cfg.default "MIT SECURE.in" $(basename $PKG)
rm $(basename $PKG)
sha256sum $GEN
gpg --sign $GEN
rm $GEN
cp $PKG $PKG.sig dist
rsync -r dist/ athena:waffles
