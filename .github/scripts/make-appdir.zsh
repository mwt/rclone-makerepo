#!/bin/zsh

# Get git directory
REPO_DIR="${0:a:h:h:h}"
REPO_NAME="${REPO_DIR##*/}"

# Clean folder
"${REPO_DIR}/clean.zsh"

# Setup folders
"${REPO_DIR}/initial-setup/2-enviroment.zsh"

mkdir "${REPO_DIR}/temp/"

wget -O "${REPO_DIR}/temp/linuxdeploy-x86_64.AppImage" "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
chmod +x "${REPO_DIR}/temp/linuxdeploy-x86_64.AppImage"

"${REPO_DIR}/temp/linuxdeploy-x86_64.AppImage" \
--appdir="${REPO_DIR}" -d "${REPO_DIR}/rclone-makerepo.desktop" \
-e "$(which jq)" \
-e "$(which rpm)" -e "$(which createrepo_c)" \
-e "$(which reprepro)"

rm -r "${REPO_DIR}/temp/"

# Package appdir as tarball
cd "${REPO_DIR}/.."
tar --exclude="${REPO_NAME}/.*" -czvf "rclone-makerepo.tar.gz" "${REPO_NAME}/"
