#!/bin/sh

## Basic dependencies:
#  - sed: used to read a config file
#  - gpg: sign repos
#  - wget: download json and packages
#  - zsh: build script is in zsh
#  - jq: process json files
#  - git: to install reprepro
#
## APT repos:
#  - reprepro: makes apt repos (fork installed after)
#
## YUM repos:
#  - rpm: get version info for renaming
#  - createrepo-c: make repo metadata
#

sudo apt update && sudo apt -y install \
sed gpg wget zsh jq git \
rpm createrepo-c

## Install build deps for reprepro
sudo apt -y install build-essentials \
debhelper libgpgme-dev libdb-dev zlib1g-dev libbz2-dev liblzma-dev libarchive-dev shunit2 db-util

# Install fork of reprepro for multiple versions
git clone https://github.com/ionos-cloud/reprepro.git "./temp"
cd "./temp"
./configure && make && sudo make install 

cd -
rm -rf "./temp"
