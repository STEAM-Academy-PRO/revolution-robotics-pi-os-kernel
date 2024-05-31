# Build a linux kernel for Pi-OS

Based on https://www.raspberrypi.com/documentation/computers/linux_kernel.html#getting-your-code-into-the-kernel and https://github.com/theAndreas/raspberrypi-kernel64-rt/tree/master

## Install dependencies

`./setup.sh`

## Edit configuration

Optional step if you want to edit the configurations in `config/`.

`./configure.sh [kernel, kernel7l]`

- `kernel`: Raspberry Pi Zero W
- `kernel7`: Raspberry Pi Zero 2 W

## Build kernels

`./build-all.sh`

The result will be a .deb in the `deb-package/` folder. Copy this file to the OS builder,
as `stage0/02-firmware/files/raspberrypi-kernel_armhf.deb` and generate a new image.
