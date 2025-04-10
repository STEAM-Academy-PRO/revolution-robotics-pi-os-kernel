#!/bin/bash

source ./common.sh $1

download_sources
cd linux

make O=$BUILD_DIR ARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN $DEFCONFIG
cp $ROOT_DIR/$CUSTOM_CONFIG_FILE $BUILD_DIR/.config
make O=$BUILD_DIR ARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN menuconfig

cp $BUILD_DIR/.config $ROOT_DIR/$CUSTOM_CONFIG_FILE
