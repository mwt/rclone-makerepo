#!/bin/sh

## Basic dependencies:
#  - sed: used to read a config file
#  - gpg: sign repos
#  - wget: download json and packages
#  - zsh: build script is in zsh
#
## YUM repos:
#  - rpm: get version info for renaming
#

sudo apt update && sudo apt -y install \
sed gpg wget zsh git \
rpm
