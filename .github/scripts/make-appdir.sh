#!/bin/sh

mkdir ./temp/

wget -O "./temp/linuxdeploy-x86_64.AppImage" "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"

./temp/linuxdeploy-x86_64.AppImage \
--appdir=. -d ./rclone-makerepo.desktop \
-e $(which gpg) -e $(which wget) -e $(which zsh) -e $(which jq) -e $(which git) \
-e $(which rpm) -e $(which createrepo-c) \
-e 
