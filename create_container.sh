#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Compiling default gcc"
    gcc_version=9.2.0
else
    gcc_version=$1
    echo "Comiling gcc ${gcc_version}"
fi

echo "podman build -t centos7-gcc${gcc_version} --build-arg GCC_VERSION=${gcc_version} ."
podman build -t centos7-gcc:${gcc_version} --build-arg GCC_VERSION=${gcc_version} .