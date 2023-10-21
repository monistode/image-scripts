#!/bin/sh

git clone https://github.com/u-boot/u-boot.git

cd u-boot

git checkout v2021.07

git checkout -b v2021.07_mine_fpga_boot_mac

cp ../config_files/config_distro_bootcmd.h include/config_distro_bootcmd.h
cp ../config_files/socfpga_common.h include/configs/socfpga_common.h

make ARCH=arm socfpga_de10_nano_defconfig

make ARCH=arm -j 24
