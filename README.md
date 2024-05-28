# Build a linux kernel for Pi-OS

Based on https://www.raspberrypi.com/documentation/computers/linux_kernel.html#getting-your-code-into-the-kernel

## Install dependencies

`./setup.sh`

## Edit configuration

Optional step if you want to edit the configurations in `config/`.

`./configure.sh [v1, v2]`

- `v1`: Raspberry Pi Zero W
- `v2`: Raspberry Pi Zero 2 W

## Build kernel

`./build.sh [v1, v2]`

- `v1`: Raspberry Pi Zero W
- `v2`: Raspberry Pi Zero 2 W
