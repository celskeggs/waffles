#!/bin/bash
set -e
rm -f wafflepkg/wafflepkg-*.pkg.tar.xz
(cd wafflepkg && makepkg)
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
tar -czf $GEN init_disks.sh init_inside.sh cela.asc mirrorlist syslinux.cfg.default $(basename $PKG)
rm $(basename $PKG)
sha256sum $GEN
cp $PKG dist
cp dist/* ~/athena/waffles/
