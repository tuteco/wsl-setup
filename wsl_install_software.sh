#!/bin/bash
# prepare a fresh WSL Ubuntu distro for development of dockerized python applications
# provied by: .tuteco - the data and knowledge experts

# update and install required software packages
sudo apt-get update \
&& sudo apt-get install --no-install-recommends -y \
make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
unzip rsync

# aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip

# saml2aws
CURRENT_VERSION=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1)
wget -c https://github.com/Versent/saml2aws/releases/download/v${CURRENT_VERSION}/saml2aws_${CURRENT_VERSION}_linux_amd64.tar.gz -O - | tar -xzv -C ~/.local/bin
chmod u+x ~/.local/bin/saml2aws
hash -r

echo '' >> ~/.profile
echo 'eval "$(saml2aws --completion-script-bash)"' >> ~/.profile

# pyenv
rm -rf ~/.pyenv
curl https://pyenv.run | bash

echo '' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

echo '' >> ~/.profile
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile

source ~/.profile
exec "$SHELL"

# activate the pyenv-virtualenv plugin
#echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
source ~/.bashrc
exec "$SHELL"

# ssh config
mkdir -p ~/.ssh
curl https://raw.githubusercontent.com/tuteco/wsl-setup/main/profile_ssh_add.txt >> ~/.profile

# install the desired python versions
pyenv install 3.10.10
pyenv install 3.9.16
pyenv global 3.10.10

# pyenv virtualenv py-invoke-basics-3.10

# poetry
curl -sSL https://install.python-poetry.org | python3 -

# development directory structure
mkdir -p ~/docker-volumes
mkdir -p ~/workspace

# echo "py-invoke-basics-3.10" >> workspace/.python-version
# cd workspace
# pip install cookiecutter invoke boto3 docker pytz nbconvert \
# mkdocs mkdocs-material mkdocs-material-extensions mkdocs-autorefs \
# mkdocs-gen-files mkdocs-literate-nav mkdocstrings mkdocstrings-python
