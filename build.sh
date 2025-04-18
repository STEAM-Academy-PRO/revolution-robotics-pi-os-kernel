#!/bin/bash

source ./common.sh $1

cd linux

make O=$BUILD_DIR ARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN -j8 $IMAGE modules dtbs

make O=$BUILD_DIR INSTALL_MOD_PATH=$INSTALL_DIR modules_install
cp $BUILD_DIR/arch/${ARCH}/boot/dts/${DTS_SUBDIR}/*.dtb $INSTALL_DIR/boot/
cp $BUILD_DIR/arch/${ARCH}/boot/dts/overlays/*.dtb* $INSTALL_DIR/boot/overlays/
cp $ROOT_DIR/linux/arch/${ARCH}/boot/dts/overlays/README $INSTALL_DIR/boot/overlays/
cp $BUILD_DIR/arch/${ARCH}/boot/$IMAGE $INSTALL_DIR/boot/$KERNEL.img
