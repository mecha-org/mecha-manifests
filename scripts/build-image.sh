#!/bin/bash

# set the environment
# source ./build-env.sh

# Set yocto environment
# source setup-environment ./build

# set the build dir
source ./build-setup.sh

# Build the image
bitbake mecha-image-core