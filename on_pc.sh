#!/bin/bash

SDX1="${1}1"
SDX2="${1}2"
fdisk ${1}

cd /tmp

mkfs.vfat $SDX1
mkfs.ext4 $SDX2

mkdir boot
mkdir root

mount $SDX1 boot
mount $SDX2 root

wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz

bsdtar -xpf ArchLinuxARM-rpi-armv7-latest.tar.gz -C root
sync

mv root/boot/* boot
sync


echo "mediapi" >> root/etc/hostname

# Network
echo "[Match]" >> "root/etc/systemd/network/20-wired.network"
echo "Name=eth0" >> "root/etc/systemd/network/20-wired.network"
echo "[Network]" >> "root/etc/systemd/network/20-wired.network"
echo "Address=192.168.2.119/24" >> "root/etc/systemd/network/20-wired.network"
echo "Gateway=192.168.2.1" >> "root/etc/systemd/network/20-wired.network"
echo "DNS=192.168.2.120" >> "root/etc/systemd/network/20-wired.network"

wget https://raw.githubusercontent.com/JustusDinera/archarm-install/main/on_pi.sh

umount "${1}*"

echo "Good luck this time!"