#!/bin/bash

./build.sh v1
./build.sh v2

# create a tar.gz out of install/boot/ and install/lib/
mkdir -p out || true
tar -czf out/kernel.tar.gz -C install boot lib
