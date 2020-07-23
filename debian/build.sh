#!/bin/bash


# Make sure you install the following packages:
# libcurl4-nss-dev
# libnsync-dev
# android-libboringssl-dev
# libdouble-conversion-dev
# libsnappy-dev
# libgif-dev
# zlib1g-dev

set -x

# Revert files before patching
# git checkout -f

# Ensure packages build with no Internet access
export http_proxy=127.0.0.1:9
export https_proxy=127.0.0.1:9

export TF_IGNORE_MAX_BAZEL_VERSION=1
export PYTHON_BIN_PATH=/usr/bin/python3

# yes "" | ./configure

bazel build \
    -k \
    --verbose_failures \
    --repository_cache= \
    --config=opt \
    --distdir=./debian/dist \
    --repo_env=TF_SYSTEM_LIBS=nsync,curl,boringssl,double_conversion,snappy,gif,zlib \
    //tensorflow:tensorflow_framework

# Revert files after build
#git checkout -f


