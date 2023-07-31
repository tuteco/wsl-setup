#!/bin/bash
# prepare a fresh WSL Ubuntu distro for development of dockerized python applications
# provided by: tuteco GmbH - the data and knowledge experts

# define the podman source repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/xUbuntu_$(lsb_release -rs)/Release.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg > /dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg]\
    https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/xUbuntu_$(lsb_release -rs)/ /" \
  | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:unstable.list > /dev/null

# update and install required software packages
sudo apt-get update \
&& sudo apt-get install --no-install-recommends -y \
make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
unzip rsync wslu binfmt-support podman

# enable the systemd socket to ensure docker compatibility
systemctl --user enable podman.socket
systemctl --user start podman.socket

# create symbolc link to enable PyCharm compatibility to access the unix socket
sudo ln -sfvT /run/user/${UID}/podman/podman.sock /var/run/docker.sock

# required software tools directories
mkdir -p .local/bin
mkdir ~/tmp

# aws cli installation
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip

# pyenv installation
rm -rf ~/.pyenv
curl https://pyenv.run | bash

# add the env variables to .bashrc and .profile
echo '' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

echo '' >> ~/.profile
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile

# activate the pyenv env variables, so that we can install the python version later
source ~/.profile
exec "$SHELL"

# add ssh config to the profile
mkdir -p ~/.ssh
echo '' >> ~/.profile
curl https://raw.githubusercontent.com/tuteco/wsl-setup/main/profile_ssh_add.txt >> ~/.profile

# add the formatting of the prompt for git branches
echo '' >> ~/.bashrc
curl https://raw.githubusercontent.com/tuteco/wsl-setup/main/git_branch_to_brashrc.txt >> ~/.bashrc

# install the desired python versions
# we use 3.11 as default version for productive use
pyenv install 3.11.4
pyenv install 3.10.12
pyenv global 3.11.4

# install poetry
curl -sSL https://install.python-poetry.org | python3 -

# development directory structure
mkdir -p ~/workspace/local_pg/db/data
mkdir -p ~/workspace/pump_config
mkdir -p ~/workspace/log

echo '-------------------------------------------------------'
echo 'please restart your WSL2 to activate all changes'
echo '-------------------------------------------------------'
