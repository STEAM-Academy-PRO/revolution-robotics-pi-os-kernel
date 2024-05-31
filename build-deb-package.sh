#!/bin/bash
# Based on https://github.com/theAndreas/raspberrypi-kernel64-rt/tree/master

# Set pacakge version without epoche
DEB_PACKAGE_VERSION_WITHOUT_EPOCHE=1.20230405-1

# Do not change the following variables!
INITIAL_WORKING_DIR=$(pwd)
CURRENT_WORKING_DIR=$(pwd)
PACKAGE_NAME=raspberrypi-kernel
DEB_PACKAGE_VERSION=1:${DEB_PACKAGE_VERSION_WITHOUT_EPOCHE}
PACKAGE_FILE_NAME=${PACKAGE_NAME}_armhf.deb
INSTALL_DEB_SCRIPT_FILE_NAME=install-deb.sh

# INSTALL_FOLDER_NAME must be the same value as ${INSTALL_FOLDER_NAME} in build-kernel.sh
INSTALL_FOLDER_NAME=install
DEB_PACKAGE_FOLDER_NAME=deb-package

INSTALL_FOLDER_PATH=${CURRENT_WORKING_DIR}/${INSTALL_FOLDER_NAME}
DEB_PACKAGE_FOLDER_PATH=${CURRENT_WORKING_DIR}/${DEB_PACKAGE_FOLDER_NAME}
PACKAGE_NAME_FOLDER_PATH=${DEB_PACKAGE_FOLDER_PATH}/${PACKAGE_NAME}

echo "Clear folder ${DEB_PACKAGE_FOLDER_PATH}"
rm -rf ${DEB_PACKAGE_FOLDER_PATH}
mkdir -p ${PACKAGE_NAME_FOLDER_PATH}

INSTALL_MOD_PATH=${PACKAGE_NAME_FOLDER_PATH}
INSTALL_DTBS_PATH=${INSTALL_MOD_PATH}/boot

echo "Create folder ${INSTALL_MOD_PATH}"
mkdir -p ${INSTALL_MOD_PATH}
echo "Create folder ${INSTALL_MOD_PATH}/boot"
mkdir -p ${INSTALL_MOD_PATH}/boot
echo "Create folder ${INSTALL_MOD_PATH}/overlays"
mkdir -p ${INSTALL_DTBS_PATH}/overlays/

echo "Copying kernel modules"
cp -r ${INSTALL_FOLDER_PATH}/lib ${PACKAGE_NAME_FOLDER_PATH}/lib

echo "Copying kernel device tree blobs"
cp ${INSTALL_FOLDER_PATH}/boot/*.dtb ${INSTALL_DTBS_PATH}/

echo "Copying and renaming the kernel image"
cp ${INSTALL_FOLDER_PATH}/boot/*.img ${INSTALL_DTBS_PATH}/

echo "Copying kernel device tree blobs overlays"
cp ${INSTALL_FOLDER_PATH}/boot/overlays/* ${INSTALL_DTBS_PATH}/overlays

echo "Create folder ${CURRENT_WORKING_DIR}/DEBIAN"
mkdir -p ${PACKAGE_NAME_FOLDER_PATH}/DEBIAN

# Switch working directory
cd ${PACKAGE_NAME_FOLDER_PATH}/DEBIAN
CURRENT_WORKING_DIR=$(pwd)
echo "Switch to ${CURRENT_WORKING_DIR}"

CONTROL_FILE_NAME=control
POST_INSTALL_FILE_NAME=postinst

CONTROL_FILE=${CURRENT_WORKING_DIR}/${CONTROL_FILE_NAME}
POST_INSTALL_FILE=${CURRENT_WORKING_DIR}/${POST_INSTALL_FILE_NAME}

echo "Creating control file ${CONTROL_FILE}"
cat << EOF > ${CONTROL_FILE_NAME}
Package: ${PACKAGE_NAME}
Source: raspberrypi-firmware
Installed-Size: `du -ks ../|cut -f 1`
Version: ${DEB_PACKAGE_VERSION}
Architecture: armhf
Maintainer: Dániel Buga <daniel.buga@steamacademy.pro>
Breaks: raspberrypi-bootloader (<< 1.20160324-1)
Replaces: raspberrypi-bootloader (<< 1.20160324-1)
Provides: linux-image, wireguard-modules (= 1.0.0)
Section: kernel
Priority: optional
Multi-Arch: foreign
Homepage: https://github.com/raspberrypi/firmware
Description: Raspberry Pi bootloader.
 This package contains the Raspberry Pi Linux kernel.
EOF

echo "Creating post install file ${POST_INSTALL_FILE}"
cat << EOF > ${POST_INSTALL_FILE_NAME}
#!/bin/bash
chmod -R +x /boot/overlays
chmod +x /boot/*.img
chmod +x /boot/*.dtb
EOF
chmod 0755 ${POST_INSTALL_FILE}

# Switch working directory
cd ../..
CURRENT_WORKING_DIR=$(pwd)
echo "Switch to ${CURRENT_WORKING_DIR}"

echo "Building debian package"
dpkg-deb --build --root-owner-group -Zxz ${PACKAGE_NAME}
mv ${PACKAGE_NAME}.deb ${PACKAGE_FILE_NAME}

echo "Created package: $(realpath ${PACKAGE_FILE_NAME})"

# Switch working directory
cd ${INITIAL_WORKING_DIR}
CURRENT_WORKING_DIR=$(pwd)
echo "Switch to ${CURRENT_WORKING_DIR}"

INSTALL_DEB_SCRIPT_FILE=${CURRENT_WORKING_DIR}/deb-package/${INSTALL_DEB_SCRIPT_FILE_NAME}

echo "Creating deb package install script file ${INSTALL_DEB_SCRIPT_FILE}"
cat << EOF > ${INSTALL_DEB_SCRIPT_FILE}
#!/bin/sh

dpkg -r --force-depends raspberrypi-kernel
dpkg -i ./${PACKAGE_FILE_NAME}

#apt-mark hold raspberrypi-kernel
EOF
