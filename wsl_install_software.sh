#!/bin/bash
#
sudo apt-get update \
&& sudo apt-get install --no-install-recommends -y \
make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev unzip


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

rm awscliv2.zip


rm -rf ~/.pyenv

curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile

source ~/.profile
exec "$SHELL"

# install and activate the pyenv-virtualenv plugin
sudo git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

source ~/.bashrc
exec "$SHELL"

# install the desired python versions
pyenv install 3.10.8 
pyenv install 3.9.15 

pyenv global 3.10.8

pyenv virtualenv 3.10.8 py-invoke-basics-3.10

curl -sSL https://install.python-poetry.org | python3 -

rm -rf ~/docker-volumes
mkdir ~/docker-volumes

rm -rf ~/workspace
mkdir ~/workspace




