# mecha-manifests

## Steps to setup yocto build environment

1. Install dependencies

```sh
$ apt update
$ apt install repo -y
```

2. Create folders for `build`, `esdk`

```sh
$ mkdir build && mkdir esdk
```

3. Initialize repo with this repository as source, branch and the manifest. Sync the repo -

```sh
$ cd build
$ repo init -u git@github.com:mecha/mecha-manifests.git -b kirkstone -m mecha-comet-m-image-core-5.15.xml
$ repo sync
```
