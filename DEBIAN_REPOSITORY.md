
## Setting up debian package feed and repository

1. In the yocto environment, add following variables to the `local.conf` or `distro/distro.conf`

```sh
...
PACKAGE_CLASSES ?= "deb"    # Enables package management
PACKAGE_FEED_ARCHS = ".."   # TODO
PACKAGE_FEED_BASE_PATHS = ".."  # TODO
PACKAGE_FEED_URIS = ".."    # TODO
```

If you only want to enable support for `apt` then add to `IMAGE_INSTALL`, in your `local.conf` or `distro/distro.conf`

```sh
IMAGE_INSTALL:append = "apt"
```

2. To build or update the package-index, run the following command

```sh
$ bitbake package-index
```

Note - Do this everytime image is rebuilt or a new recipe is built/

4. Host the `build_dir/tmp/deploy/deb` on a public server

```
$ cd tmp/deploy
$ tar -cvf deb.tar.gz ./deb
$ scp ...


# On the server
$ tar -xvf deb.tar.gz .
$ cd deb/all/
$ http-server -a 0.0.0.0 .
```

Note - `http-server` can be installed via `npm`, recommend using Apache or NGINX.

Map the path `./deb/all/` to `/comet-m/main/dists/mechanix-5.15/main/binary-arm64/`, example of the url

```
$ http://.../dists/mechanix-5.15/main/binary-arm64/Packages
```

3. On the device, append to `/etc/apt/sources.list`

```bash
# mechanix debian repository, trusted=yes as packages as not signed
deb [trusted=yes] http://url-to-debian-repo/comet-m mechanix-5.15 main
```

Here `mechanix-5.15` is distribution and `main` is the component

4. Update your `apt` sources

```
$ apt update
```

5. Optional: To enable signing of packages, add to your `local.conf` or `distro/distro.conf`

```sh
# Inherit sign-deb.bbclass to enable signing functionality
INHERIT += " sign-deb"
# Define the GPG key that will be used for signing.
RPM_GPG_NAME = "key_name"
# Provide passphrase for the key
RPM_GPG_PASSPHRASE = "passphrase"

# Optional - 
# Specifies a gpg binary/wrapper that is executed when the package is signed.
GPG_BIN = ""
# Specifies the gpg home directory used when the package is signed.
GPG_PATH = ""
```

### TODO
[] Add Signing support