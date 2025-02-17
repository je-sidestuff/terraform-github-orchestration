#!/bin/bash

TF_ENV_VERSION="v3.0.0"

apt update -y
apt install -y python3-pip

pip3 install pre-commit

mkdir /apps/
git clone --depth=1 -b $TF_ENV_VERSION https://github.com/tfutils/tfenv.git /apps/.tfenv
chmod 777 /apps/.tfenv

echo 'source /scripts/configure_devcontainer_environment.sh' >> /home/vscode/.bashrc

echo 'source /scripts/devcontainer_runtime_startup.sh' >> /home/vscode/.bashrc
