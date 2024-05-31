#!/bin/bash

./build.sh kernel
./build.sh kernel7

./build-deb-package.sh
