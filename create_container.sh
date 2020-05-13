#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    gcc_version=10.1.0
else
    gcc_version=$1
fi

echo "Updating centos7 image"
podman pull centos:7

echo "Building centos7-gcc:${gcc_version} image"
podman build -t centos7-gcc:${gcc_version} --build-arg GCC_VERSION=${gcc_version} .
