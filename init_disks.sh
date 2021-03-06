#!/bin/bash

set -e

if [ "$1" = "" ]
then
	echo "Usage: $0 sda <pass>" 1>&2
	exit 1
fi

DISK=/dev/$1
PKG=$(dirname $0)/wafflepkg*.pkg.tar.xz
if [ "$(ls $PKG | wc -l)" != "1" ]
then
	echo "Bad dist"
	exit 1
fi

read -p "Passphrase: " -s PASS
echo
read -p "Pass again: " -s PASS2
echo

if [ "${#PASS}" -lt 8 -o "$PASS" != "$PASS2" ]
then
	echo "Bad pass"
	exit 1
fi

timedatectl set-ntp true
dd if=/dev/zero of=$DISK count=16
# TODO: swap space
echo "n p 1 2048 +300M" "n p 2 616448 " "w" | tr " " "\n" | fdisk $DISK
echo "$PASS" | cryptsetup luksFormat "$DISK"2
echo "$PASS" | cryptsetup open "$DISK"2 cryptroot
mkfs -t ext4 /dev/mapper/cryptroot </dev/null
mkfs -t ext4 -O '^64bit' "$DISK"1 </dev/null
mount -t ext4 /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount -t ext4 "$DISK"1 /mnt/boot
mv mirrorlist /etc/pacman.d/mirrorlist
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
cp $(dirname $0)/init_inside.sh /mnt
cp $(dirname $0)/wafflepkg*.pkg.tar.xz /mnt
cp $(dirname $0)/cela.asc /mnt
arch-chroot /mnt /init_inside.sh "$PASS"
rm /mnt/init_inside.sh
cp syslinux.cfg.default /mnt/boot/syslinux/syslinux.cfg
sed -i "s/{{UUID}}/$(lsblk -f "$DISK"2 --output UUID | head -n 2 | tail -n 1)/g" /mnt/boot/syslinux/syslinux.cfg
sync
