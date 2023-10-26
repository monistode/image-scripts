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

# Compiling u-boot
Make sure you install these packages:
```bash
sudo apt install gcc-arm-linux-gnueabihf
```

Now export the cross-compiler path
```bash
export CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
```

And run the script
```bash
./gen-uboot.sh
```

# Compiling linux
Install all these packages:
```bash
sudo apt install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev \
libudev-dev libpci-dev libiberty-dev libmpc-dev libgmp3-dev autoconf \
bc debootstrap gcc-arm-none-eabi
```

Same as with u-boot, export the cross-compiler path
```bash
export CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
```

And run the script
```bash
./genkernel.sh
```

# Setting up rootfs
Install these packages:
```bash
sudo apt install qemu-user-static gcc-arm-linux-gnueabihf
```

Run the script:
```bash
./genroot.sh
```

# The image itself
You caould just
```bash
./imggen.sh
```

But there's options, so read through them before using it
```bash
./imggen.sh -h
```

That's all!
