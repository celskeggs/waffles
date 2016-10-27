#!/bin/bash

set -e

if [ "$1" = "" ]
then
	echo "Usage: $0 <pass>" 1>&2
	exit 1
fi

PASS=$1

ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
sed -i "s/#en_US[.]UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf
echo "KEYMAP=dvorak" >/etc/vconsole.conf
echo "ccu-$(od -t x1 /dev/urandom -N 2 -A n | sed 's/ //g')" >/etc/hostname
pacman -S --noconfirm wpa_supplicant iw dialog sudo syslinux polkit networkmanager
useradd -m -G wheel,adm,rfkill,log,sys,systemd-journal,users,uucp,lp -s /bin/bash cela
echo "cela:$PASS" | chpasswd
echo "cela ALL=(ALL) ALL" >/etc/sudoers.d/cela
sed -i 's/ keyboard//' /etc/mkinitcpio.conf
sed -i 's/filesystems/keyboard keymap encrypt filesystems/' /etc/mkinitcpio.conf
mkinitcpio -p linux
syslinux-install_update -i -a -m
systemctl enable NetworkManager
