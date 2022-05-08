#!/bin/zsh

SCRIPT_DIR=${0:a:h}
REPO_DIR=${SCRIPT_DIR:h}

# cd to main repo dir
cd "$SCRIPT_DIR/.."

# create downloads folder
mkdir -p ./staging

# replace gpg code if there is an argument
if [[ -z $1 ]] {
    # do nothing
} else {
    sed -i "s/^SignWith: .\+$/SignWith: $1/" "$REPO_DIR/reprepro/conf/distributions"
}

# create reprepro options file
cat << EOF > "$REPO_DIR/reprepro/conf/options"
basedir $REPO_DIR/dist/deb
dbdir $REPO_DIR/reprepro/db
logdir $REPO_DIR/reprepro/logs
EOF

# create folders for reprepro
mkdir -p ./reprepro/db/
mkdir -p ./reprepro/logs/
mkdir -p ./dist/deb/

# create folder for yum repo
mkdir -p ./dist/rpm/

# compile functions (not required)
zcompile ./functions.zsh

# undo cd
cd -

echo "Install gpg key yourself"
