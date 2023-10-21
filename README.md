# DE10-Nano linux scripts

This repository contains the scripts for facilitating (**Note: Not generating**) the linux image for the de10-nano board generation

Should you just need the image, ask one of the guys that worked on this project - though they will probably not respond to you :=(

## Description

Here's a rundown of what the scripts do:
- `imggen.sh` - generates the SD card image
- `genroot.sh / genrootfs_chroot.sh` - the scripts for generating the rootfs wiht `debootstrap`
- `gen-uboot.sh` - pulls and compiles the u-boot bootloader
- `genkernel.sh` - pulls and compiles the kernel.

## Reqirements

Make sure qou install all these packages:
```bash
sudo apt install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev \
libudev-dev libpci-dev libiberty-dev libmpc-dev libgmp3-dev autoconf \
bc debootstrap qemu-user-static
```

That's all!
