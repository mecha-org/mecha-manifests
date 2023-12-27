# mecha-manifests

## Steps to setup yocto build environment

1. Install dependencies

```sh
$ apt update
$ apt install -y gawk wget git repo diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales
```

2. Initialize repo with this repository as source, branch and the manifest. Sync the repo -

```sh
$ mkdir yocto-build
$ cd yocto-build
$ repo init -u https://github.com/mecha-org/mecha-manifests.git -b mickledore -m mecha-comet-m-image-core-6.1.22.xml
$ repo sync
```

Note: When you sync the repo for first time, key in your name and email

3. Setup the bitbake `local.conf`

```sh
DISTRO=mechanix-xwayland MACHINE=mecha-comet-m-gen1 source comet-m-setup-release.sh -b build
```

4. Start building the image

```sh
bitbake mecha-image-core
```
