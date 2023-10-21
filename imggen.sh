#!/bin/sh

show_help() {
    echo "imggen - A tool for creating images for the DE10-Nano devboard
SHOULD BE USED WITH ROOT!

Flags:
    -h - help
    -o file - the path to the output file (DEFAULT = 'sdcard.img')
    -k file - the path to the kernel (DEFAULT = 'config_files/zImage')
    -d file - the path to the dtb file for the SOC (DEFAULT = 'config_files/socfpga_cyclone5_de0_nano_soc.dtb')
    -b file - the path to bootloader (DEFAULT = 'u-boot/u-boot-with-spl.sfp')
    -r file - the path to the rootfs tarball (DEFAULT = 'rootfs.tar.bz2')"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file="sdcard.img"
kernel_file="config_files/zImage"
dtb_file="config_files/socfpga_cyclone5_de0_nano_soc.dtb"
boot_file="u-boot/u-boot-with-spl.sfp"
rootfs_file="rootfs.tar.bz2"

while getopts ":h?:v:o:k:d:b:" opt; do
  case "$opt" in
    h|\?)
      show_help
      # exit 0
      ;;
    o)  output_file=$OPTARG
      ;;
    k)  kernel_file=$OPTARG
      ;;
    d)  dtb_file=$OPTARG
      ;;
    b)  boot_file=$OPTARG
      ;;
    r)  rootfs_file=$OPTARG
      ;;
  esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

make_image() {
    FNAME=$1
    BOOTLOADER_FILE=$2
    KERNEL_FILE=$3
    DTB_FILE=$4
    ROOTFS_FILE=$(realpath $5)

    # Create the image file
    fallocate -l 2G $FNAME

    # Create a loopback device to partition
    DEVICE=$(losetup --show -f $FNAME)
    SED_DEVICE=$(echo $DEVICE | sed 's/\//\\\//g')

    cat ./config_files/sdcard.sfdisk | sed "s/\/dev\/loop0/${SED_DEVICE}/g" > sdcard.conf

    # Partition the image
    sfdisk $DEVICE < sdcard.conf
    rm sdcard.conf

    # Make sure the partitions are visible
    partprobe $DEVICE
    mkfs -t vfat "${DEVICE}p1"
    mkfs.ext4 "${DEVICE}p2"

    # Setup the bootloader
    dd if=$BOOTLOADER_FILE of="${DEVICE}p3" bs=64k seek=0 oflag=sync

    # Setup the boot partition
    mkdir -p fat
    mount "${DEVICE}p1" fat

    cp $KERNEL_FILE fat/zImage
    cp $DTB_FILE fat/socfpga_cyclone5_de0_nano_soc.dtb

    echo "LABEL Linux Default" > extlinux.conf
    echo "    KERNEL ../zImage" >> extlinux.conf
    echo "    FDT ../socfpga_cyclone5_de0_nano_soc.dtb" >> extlinux.conf
    echo "    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" >> extlinux.conf

    mkdir -p fat/extlinux
    cp extlinux.conf fat/extlinux

    umount fat
    rmdir fat

    rm extlinux.conf

    # Setup the root partition
    mkdir -p ext4
    mount "${DEVICE}p2" ext4

    # cd ext4
    tar -xf "${ROOTFS_FILE}" -C ext4

    umount ext4
    rmdir ext4

    losetup -d $DEVICE
}

make_image $output_file $boot_file $kernel_file $dtb_file $rootfs_file
