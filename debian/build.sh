#!/bin/bash


# Make sure you install the following packages:
# libcurl4-nss-dev
# libnsync-dev
# android-libboringssl-dev
# libdouble-conversion-dev
# libsnappy-dev
# libgif-dev
# zlib1g-dev
# libprotobuf-dev
# libgrpc++-dev
# libjsoncpp-dev
# libjpeg62-turbo-dev
# nasm

set -x

# Revert files before patching
# git checkout -f

# Ensure packages build with no Internet access
export http_proxy=127.0.0.1:9
export https_proxy=127.0.0.1:9

export TF_IGNORE_MAX_BAZEL_VERSION=1
export PYTHON_BIN_PATH=/usr/bin/python3

# yes "" | ./configure

# To be enabled
# re2, boringssl
/usr/bin/bazel build \
    -k \
    --verbose_failures \
    --repository_cache= \
    --config=opt \
    --distdir=./debian/dist \
    --repo_env=TF_SYSTEM_LIBS=nsync,curl,double_conversion,snappy,gif,zlib,com_google_protobuf,com_github_grpc_grpc,jsoncpp_git,libjpeg_turbo,nasm \
    --override_repository=bazel_skylib=$PWD/debian/mock_repos/bazel_skylib \
    --override_repository=rules_cc=$PWD/debian/mock_repos/rules_cc \
    --override_repository=rules_java=$PWD/debian/mock_repos/rules_java \
    --override_repository=farmhash_archive=$PWD/debian/dist/farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45 \
    //tensorflow:tensorflow_framework

# Revert files after build
#git checkout -f


