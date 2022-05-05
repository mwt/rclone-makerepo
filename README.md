# Generate repo for Rclone

This repository contains scripts that generate apt and yum repositories for Rclone. It is designed to be run at regular intervals using a cron job. However, it can also be run via [webhook](https://github.com/adnanh/webhook) when new packages are released. The repository consists of three main scripts. 

1. The first setup script, [`initial-setup/1-install-packages.sh`](./initial-setup/1-install-packages.sh), installs the required packages. It requires sudo access and should be run only once.
2. The second setup script, [`initial-setup/2-enviroment.zsh`](./initial-setup/2-enviroment.zsh), sets up the directory structure and dynamic configuration files. It can be run by an unprivileged user. It should be run directly only once.
3. The main script, [`build.zsh`](./build.zsh), generates the apt repo in `dist/deb` using [reprepro](https://salsa.debian.org/brlink/reprepro) and generates the yum repo in `dist/rpm` using [createrepo-c](https://github.com/rpm-software-management/createrepo_c). It should be rerun regularly to add updated packages to the repository.
 
