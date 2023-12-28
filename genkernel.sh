#!/bin/sh

git clone https://github.com/altera-opensource/linux-socfpga.git --depth 1

cd linux-socfpga

git checkout socfpga-6.1.38-lts

make ARCH=arm socfpga_defconfig

cp ../config_files/linux_config .config

make ARCH=arm LOCALVERSION=zImage -j24
