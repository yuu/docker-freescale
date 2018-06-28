# docker-freescale
[![](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)]()

This project is encapsulate build environment of Yocto for freescale/ARM in Docker

## Usage

## Docker build

`$ docker build --build-arg http_proxy=${http_proxy} --build-arg https_proxy=${http_proxy} -t <tag> .`

## Docker run

`$ docker run -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} --name=<unique name> -ti <tag>`

### Find machine name

`$ find sources -name 'machine' -exec ls {} \; |egrep -v "(include|machine)" |sed -e 's/\.conf//' |sort`

### Setup backend

- Wayland

  `$ EULA=1 MACHINE=<machine name> source fsl-setup-release.sh -b build-wayland -e wayland`

- Linux FB

  `$ EULA=1 MACHINE=<machine name> source fsl-setup-release.sh -b build-fb -e fb`

### Build image

- Wayland

  `$ bitbake fsl-image-wayland`

- Linux FB

  `$ bitbake fsl-image-fb`

## My recommended bitbake configuration

local.conf
```
PACKAGE_CLASSES = "package_ipk"
IMAGE_INSTALL_append = "vim git fontconfig"
IMAGE_FEATURES += "package-management"

DISTRO_FEATURES_append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"
VIRTUAL-RUNTIME_initscripts = ""
```

## How to mount host directory in docker container ?

Add `-v` docker run option.
```
$ docker run -v /tmp:/tmp -ti <tag>
```

local.conf
```
DL_DIR = "/tmp/downloads"
SSTATE_DIR = "/tmp/sstate-cache/${MACHINE}"
DEPLOY_DIR = "/tmp/deploy"
```

## Requirements

* Docker v1.9 or later
