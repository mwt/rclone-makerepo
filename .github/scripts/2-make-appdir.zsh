#!/bin/zsh

# Get git directory
REPO_DIR="${0:a:h:h:h}"
REPO_NAME="${REPO_DIR##*/}"

# delete every file that is not tracked by the repo
cd "${REPO_DIR}"
git clean -dfx

mkdir "${REPO_DIR}/temp/"

wget -O "${REPO_DIR}/temp/linuxdeploy-x86_64.AppImage" "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
chmod +x "${REPO_DIR}/temp/linuxdeploy-x86_64.AppImage"

"${REPO_DIR}/temp/linuxdeploy-x86_64.AppImage" \
--appdir="${REPO_DIR}" -d "${REPO_DIR}/rclone-makerepo.desktop" \
-e "$(which jq)" \
-e "$(which createrepo_c)" \
-e "$(which reprepro)"

rm -r "${REPO_DIR}/temp/"

# Package appdir as tarball
cd "${REPO_DIR}/.."
tar --exclude="${REPO_NAME}/.*" --exclude="${REPO_NAME}/clean.zsh" -czvf "rclone-makerepo.tar.gz" "${REPO_NAME}/"
