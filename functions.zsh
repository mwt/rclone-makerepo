#===================================================
# Function for RPM Repo
#===================================================

update_rpm_repo() {
    RPM_FILE="$1"
    RPM_REPO_DIR="$2"

    # query rpm version and package name
    RPM_FULLNAME=$(rpm -qp "${RPM_FILE}")

    # query rpm arch separately
    RPM_ARCH=$(rpm -qp --qf "%{arch}" "${RPM_FILE}")

    echo "Copying ${RPM_FILE} to ${RPM_REPO_DIR}/${RPM_ARCH}/${RPM_FULLNAME}.rpm"
    mkdir -p "${RPM_REPO_DIR}/${RPM_ARCH}/"
    cp "${RPM_FILE}" "${RPM_REPO_DIR}/${RPM_ARCH}/${RPM_FULLNAME}.rpm"

    # remove and replace repodata
    createrepo_c --update "${RPM_REPO_DIR}/${RPM_ARCH}"

    rm -f "${RPM_REPO_DIR}/${RPM_ARCH}/repodata/repomd.xml.asc"
    gpg --default-key "${KEYNAME}" -abs -o "${RPM_REPO_DIR}/${RPM_ARCH}/repodata/repomd.xml.asc" "${RPM_REPO_DIR}/${RPM_ARCH}/repodata/repomd.xml"
}
