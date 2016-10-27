#!/bin/bash

set -e

if [ "$1" = "" ]
then
	echo "Usage: $0 <pass>" 1>&2
	exit 1
fi

PASS=$1

echo "ccu-$(od -t x1 /dev/urandom -N 2 -A n | sed 's/ //g')" >/etc/hostname
pacman -U --noconfirm /wafflepkg*
rm /wafflepkg*
echo "cela:$PASS" | chpasswd
sed -i 's/ keyboard//' /etc/mkinitcpio.conf
sed -i 's/filesystems/keyboard keymap encrypt filesystems/' /etc/mkinitcpio.conf
mkinitcpio -p linux
syslinux-install_update -i -a -m
