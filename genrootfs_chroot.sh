#!/bin/sh

/debootstrap/debootstrap --second-stage

echo "de10nano" > /etc/hostname

mv sources.list /etc/apt/sources.list
mv interfaces /etc/network/interfaces

apt update
apt upgrade -y
apt install vim -y

echo root:root | chpasswd

echo "none		/tmp	tmpfs	defaults,noatime,mode=1777	0	0" >> /etc/fstab
echo "/dev/mmcblk0p2	/	ext4	defaults	0	1" >> /etc/fstab

systemctl enable serial-getty@ttyS0.service

apt install locales -y
echo "en_US.UTF-8" | sudo tee -a /etc/locale.gen
locale-gen

apt install openssh-server -y

apt install wireless-tools -y
apt install wpasupplicant -y
apt install haveged -y
apt install net-tools build-essential device-tree-compiler -y

systemctl reenable wpa_supplicant.service

rm /usr/bin/qemu-arm-static /genrootfs_chroot.sh

exit
