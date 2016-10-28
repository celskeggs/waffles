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
su cela -c "gpg --keyserver pgp.mit.edu --recv-keys EEA31BFF444304ABB246A0B6C634D0420F825B91"
su cela -c "ssh-keygen -f /home/cela/.ssh/id_rsa -N \"$PASS\""
echo "EEA31BFF444304ABB246A0B6C634D0420F825B91:6:" | su cela -c "gpg --import-ownertrust"
sed -i 's/ keyboard//' /etc/mkinitcpio.conf
sed -i 's/filesystems/keyboard keymap encrypt filesystems/' /etc/mkinitcpio.conf
mkinitcpio -p linux
syslinux-install_update -i -a -m
