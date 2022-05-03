#!/bin/sh

## Basic dependencies:
#  - gzip: for thoroughness 
#  - gpg: sign repos
#  - wget: download json and packages
#  - zsh: build script is in zsh
#  - jq: process json files
#
## APT repos:
#  - reprepro: makes apt repos
#
## YUM repos:
#  - rpm: get version info for renaming
#  - createrepo-c: make repo metadata
#

sudo apt update && sudo apt -y install \
gzip gpg wget zsh jq \
reprepro \
rpm createrepo-c
