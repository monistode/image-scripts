#!/bin/sh

mkdir -p rootfs

rm -rf rootfs/*

debootstrap --arch=armhf --foreign buster rootfs

cp /usr/bin/qemu-arm-static rootfs/usr/bin/

cp genrootfs_chroot.sh rootfs/

cp ./config_files/shadow rootfs

cp ./config_files/interfaces ./config_files/sources.list ./config_files/sshd_config rootfs

chroot rootfs /usr/bin/qemu-arm-static /bin/bash -c "sh genrootfs_chroot.sh"

cd rootfs

tar -cjpf ../rootfs.tar.bz2 .

cd ..
