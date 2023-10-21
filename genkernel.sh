#!/bin/sh

git clone https://github.com/altera-opensource/linux-socfpga.git

cd linux-socfpga

git checkout socfpga-5.12

make ARCH=arm socfpga_defconfig

cp ../config_files/linux_config .config

make ARCH=arm LOCALVERSION=zImage -j24
