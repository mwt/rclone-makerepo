#!/bin/zsh
#===================================================
# This script generates the repositories
#===================================================

SCRIPT_DIR=${0:a:h}

STAGING_DIR="${SCRIPT_DIR}/staging"
DEB_REPO_DIR="${SCRIPT_DIR}/dist/deb"
RPM_REPO_DIR="${SCRIPT_DIR}/dist/rpm"
REPREPRO_DIR="${SCRIPT_DIR}/reprepro"

# Name of the gpg key
KEYNAME="B7BE5AC2"

# Get function for creating deb/rpm repos
. "${SCRIPT_DIR}/functions.zsh"


#===================================================
# Get Info About Latest Release
#===================================================

# Retreive json file describing latest release
wget -qO "${STAGING_DIR}/latest.json" "https://api.github.com/repos/rclone/rclone/releases/latest" || (echo "json download failed"; exit 1)

# Get the new ID
LATEST_ID=$(jq -r '.id' "${STAGING_DIR}/latest.json")

# Only continue if the latest release ID is different from the ID in staging/version
if [[ -f "${STAGING_DIR}/version" ]] {
    if [[ "${LATEST_ID}" == $(<"${STAGING_DIR}/version") ]] {
        echo "Already latest version"
        exit 0
    } else {
        echo "Adding version ${LATEST_ID}"
    }
} else {
    echo "Adding version ${LATEST_ID}. No prior version found."
}


#===================================================
# START Update
#===================================================

# Get all download links (includes .AppImage)
DL_LINK_ARRAY=("${(f)"$(jq -r '.assets[] | .browser_download_url' "$STAGING_DIR/latest.json")"}")

# Loop over download links, download files, and make repos (using functions in functions.zsh)
for DL_LINK in ${DL_LINK_ARRAY}; {
    cd $STAGING_DIR
    DL_FILE="${DL_LINK##*/}"
    if [[ "${DL_FILE}" == *-arm.deb ]] {
        # do nothing because both arm and arm-v7 are armhf?
    } elif [[ "${DL_FILE}" == *.deb ]] {
        wget -nv "${DL_LINK}" || (echo "deb download failed"; exit 1)
        reprepro --confdir "${REPREPRO_DIR}/conf" includedeb any "${DL_FILE}"
    } elif [[ "${DL_FILE}" == *.rpm ]] {
        wget -nv "${DL_LINK}" || (echo "rpm download failed"; exit 1)
        update_rpm_repo "${DL_FILE}" "${RPM_REPO_DIR}" "${KEYNAME}"
    }
}

# Write version number so that the loop will not repeat until a new version is released
echo "${LATEST_ID}" > "${STAGING_DIR}/version"
