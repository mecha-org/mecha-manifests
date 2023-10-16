# Base Image
FROM ubuntu:20.04

# Set the DEBIAN_FRONTEND environment variable to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# ADD https://packages.ubuntu.com/dists/focal/main/binary-amd64/Packages .
RUN apt-get update && apt-get install -y \
    gawk \
    wget \
    git \
    diffstat \
    unzip \
    texinfo \
    gcc \
    build-essential \
    chrpath \
    socat \
    cpio \
    python3 \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping \
    python3-git \
    python3-jinja2 \
    libegl1-mesa \
    libsdl1.2-dev \
    python3-subunit \
    mesa-common-dev \
    zstd \
    liblz4-tool \
    file \
    nano \
    vim \
    locales \
    && rm -rf /var/lib/apt/lists/* 

# Set default shell to BASH for source
RUN rm /bin/sh && ln -s bash /bin/sh

# Set Default shell to BASH
SHELL ["/bin/bash", "-c"]

# Set locale - required for bitbake
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Check if the symbolic link 'python' already exists, and use it if it does
RUN if [ ! -e /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi

# Download and install the 'repo' tool using 'wget'
RUN wget https://storage.googleapis.com/git-repo-downloads/repo -O /usr/bin/repo && chmod a+x /usr/bin/repo

# Create user and change context
RUN useradd -U -m mecha && /usr/sbin/locale-gen en_US.UTF-8 && echo "mecha ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# change user to mecha, own the home directory
USER mecha

WORKDIR /home/mecha

RUN repo init -u https://github.com/mecha-org/mecha-manifests.git -b kirkstone -m mecha-comet-m-image-core-5.15.xml && repo sync

ARG MACHINE=mecha-comet-m-gen1
ARG DISTRO=mecha-linux
ARG EULA=1

# Set environment images
RUN echo "#!/bin/sh" >> ./build-env.sh
RUN echo "export EULA=${EULA}" >> ./build-env.sh
RUN echo "export DISTRO=${DISTRO}" >> ./build-env.sh
RUN echo "export MACHINE=${MACHINE}" >> ./build-env.sh
RUN chmod u+x ./build-env.sh

RUN printenv

# Setup the bitbake local.conf
# RUN chmod u+x ./edge-setup-release.sh
# RUN EULA=${EULA} DISTRO=${DISTRO} MACHINE=${MACHINE} ./edge-setup-release.sh -b build

# Copy the script into the image
COPY --chown=mecha:mecha scripts/build-image.sh ./build-image.sh
COPY --chown=mecha:mecha scripts/build-setup.sh ./build-setup.sh

# Make the script executable
RUN chmod u+x ./build-image.sh
RUN chmod u+x ./build-setup.sh

CMD ["./build-image.sh"]