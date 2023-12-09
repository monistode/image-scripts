FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev libmpc-dev libgmp3-dev autoconf bc debootstrap gcc-arm-none-eabi
RUN apt-get install -y qemu-user-static gcc-arm-linux-gnueabihf

ENV CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-

COPY . .

# RUN ./genkernel.sh
RUN ./genroot.sh
CMD ["./imggen.sh", "-o", "artifacts/sdcard.img"]
