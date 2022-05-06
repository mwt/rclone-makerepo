#===================================================
# Function for timestamps
#===================================================

date_time_echo() {
    local DATE_BRACKET=$(date +"[%D %T]")
    echo "$DATE_BRACKET" "$@"
}


#===================================================
# Function for RPM Repo: called by make_repos()
#===================================================

update_rpm_repo() {
    local RPM_FILE="$1"
    local RPM_REPO_DIR="$2"

    # query rpm version and package name
    local RPM_FULLNAME=$(rpm -qp "${RPM_FILE}")

    # query rpm arch separately
    local RPM_ARCH=$(rpm -qp --qf "%{arch}" "${RPM_FILE}")

    date_time_echo "Copying ${RPM_FILE} to ${RPM_REPO_DIR}/${RPM_ARCH}/${RPM_FULLNAME}.rpm"
    mkdir -p "${RPM_REPO_DIR}/${RPM_ARCH}/"
    cp "${RPM_FILE}" "${RPM_REPO_DIR}/${RPM_ARCH}/${RPM_FULLNAME}.rpm"

    # remove and replace repodata
    createrepo_c --update "${RPM_REPO_DIR}/${RPM_ARCH}"

    rm -f "${RPM_REPO_DIR}/${RPM_ARCH}/repodata/repomd.xml.asc"
    gpg --default-key "${KEYNAME}" -abs -o "${RPM_REPO_DIR}/${RPM_ARCH}/repodata/repomd.xml.asc" "${RPM_REPO_DIR}/${RPM_ARCH}/repodata/repomd.xml"
}


#===================================================
# Make Repos
# $1 : JSON file with download links
# $2 : Path to reprepro conf folder
# $3 : Path to RPM repos
#===================================================

make_repos() {
    # Get all download links (includes .AppImage)
    local DL_LINK_ARRAY=("${(f)"$(jq -r '.assets[] | .browser_download_url | select(test("\\.(deb|rpm)$"))' "$1")"}")

    # Use the reprepro keyname with rpm
    local KEYNAME=$(sed -n 's/SignWith: \(.\+\)/\1/p' "$2/distributions")

    # Loop over download links, download files, and make repos (using functions in functions.zsh)
    for DL_LINK in ${DL_LINK_ARRAY}; {
        echo $DL_LINK
        local DL_FILE="${DL_LINK##*/}"
        echo $DL_FILE
        if [[ ${DL_FILE} == *-arm.deb ]] {
            # do nothing because both arm and arm-v7 are armhf?
        } elif [[ ${DL_FILE} == *.deb ]] {
            wget -Nnv "${DL_LINK}" || (date_time_echo "deb download failed"; exit 1)
            reprepro --confdir "$2" includedeb any "${DL_FILE}"
        } elif [[ ${DL_FILE} == *.rpm ]] {
            wget -Nnv "${DL_LINK}" || (date_time_echo "rpm download failed"; exit 1)
            update_rpm_repo "${DL_FILE}" "$3" "${KEYNAME}"
        }
    }
}
