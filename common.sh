#!/bin/bash

function download_sources {
    # clone sources if missing
    if [ -d linux ] ; then
        echo "linux/ directory already exists"
    else
        git clone --depth=1 -b rpi-6.1.y https://github.com/raspberrypi/linux
    fi
}

if [ "$1" == "kernel" ]; then
    # Raspberry Pi Zero W
    KERNEL=kernel
    ARCH=arm
    DEFCONFIG=bcmrpi_defconfig
    CUSTOM_CONFIG_FILE=config/.config
elif [ "$1" == "kernel7" ]; then
    KERNEL=kernel7
    ARCH=arm
    DEFCONFIG=bcm2709_defconfig
    CUSTOM_CONFIG_FILE=config/.config-7
elif [ "$1" == "kernel7l" ]; then
    KERNEL=kernel7l
    ARCH=arm
    DEFCONFIG=bcm2711_defconfig
    CUSTOM_CONFIG_FILE=config/.config-7l
else
    echo "Usage: $0 [ v1 | v2 ]"
    exit 1
fi

if [ "$ARCH" == "arm" ]; then
    TOOLCHAIN=arm-linux-gnueabihf-
    IMAGE=Image
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
BUILD_DIR=$ROOT_DIR/build/$KERNEL
INSTALL_DIR=$ROOT_DIR/install

mkdir $BUILD_DIR || true
mkdir -p $INSTALL_DIR/boot/overlays || true

download_sources

cp $ROOT_DIR/$CUSTOM_CONFIG_FILE $BUILD_DIR/.config
