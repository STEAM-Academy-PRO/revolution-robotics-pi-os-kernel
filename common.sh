#!/bin/bash

function download_sources {
    # clone sources if missing
    if [ -d linux ] ; then
        echo "linux/ directory already exists"
    else
        git clone --depth=1 -b rpi-6.1.y https://github.com/raspberrypi/linux
    fi

    cp $CUSTOM_CONFIG_FILE build/.config
}

if [ "$1" == "v1" ]; then
    # Raspberry Pi Zero W
    KERNEL=kernel
    ARCH=arm
    DEFCONFIG=bcmrpi_defconfig
    CUSTOM_CONFIG_FILE=config/.config
elif [ "$1" == "v2" ]; then
    # Raspberry Pi Zero 2 W 32-bit
    KERNEL=kernel7
    ARCH=arm
    DEFCONFIG=bcm2709_defconfig
    CUSTOM_CONFIG_FILE=config/.config
else
    echo "Usage: $0 [ v1 | v2 ]"
    exit 1
fi

if [ "$ARCH" == "arm" ]; then
    TOOLCHAIN=arm-linux-gnueabihf-
    IMAGE=zImage
    DTS_SUBDIR=
elif [ "$ARCH" == "arm64" ]; then
    TOOLCHAIN=aarch64-linux-gnu-
    IMAGE=Image.gz
    DTS_SUBDIR=broadcom
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi


ROOT_DIR=`pwd`
BUILD_DIR=$ROOT_DIR/build
INSTALL_DIR=$ROOT_DIR/install

mkdir $BUILD_DIR || true
mkdir -p $INSTALL_DIR/boot/overlays || true
