#!/bin/sh

## Basic dependencies:
#  - gzip: for thoroughness 
#  - gpg: sign repos
#  - wget: download json and packages
#  - zsh: build script is in zsh
#  - jq: process json files
#
## APT repos:
#  - reprepro: makes apt repos (fork installed after)
#
## YUM repos:
#  - rpm: get version info for renaming
#  - createrepo-c: make repo metadata
#

sudo apt update && sudo apt -y install \
gzip gpg wget zsh jq \
rpm createrepo-c

## Install build deps for reprepro
sudo apt -y install debhelper libgpgme-dev libdb-dev libz-dev libbz2-dev liblzma-dev libarchive-dev shunit2 db-util

# Install fork of reprepro for multiple versions
git clone https://github.com/ionos-cloud/reprepro.git "$HOME/.temp-reprepro-install"
cd "$HOME/.temp-reprepro-install"
./configure && make && sudo make install 

cd -
rm -rf "$HOME/.temp-reprepro-install"
