# keepassxc in Docker

[keepassxc](https://github.com/keepassxreboot/keepassxc) running within a Docker container.  Derived from [jessfraz/dockerfiles/keepassxc](https://github.com/jessfraz/dockerfiles/blob/master/keepassxc/Dockerfile)

The `install.sh` script will build the container image and also create a wrapper shell script and a desktop launcher file for Linux systems.

To build the latest stable version:
```
./install.sh
```

To build from another branch/tag or commit id:
```
KEEPASSXC_VERSION=master ./install.sh
```
