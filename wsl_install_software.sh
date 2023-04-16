#!/bin/bash
# prepare a fresh WSL Ubuntu distro for development of dockerized python applications
# provided by: tuteco GmbH - the data and knowledge experts

# update and install required software packages
sudo apt-get update \
&& sudo apt-get upgrade -y \
&& sudo apt-get install --no-install-recommends -y \
make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
unzip rsync wslu binfmt-support

# required software tools directories
mkdir -p .local/bin
mkdir ~/tmp


# aws cli installation
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip

# saml2aws installation
CURRENT_VERSION=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1)
wget -c https://github.com/Versent/saml2aws/releases/download/v${CURRENT_VERSION}/saml2aws_${CURRENT_VERSION}_linux_amd64.tar.gz -O - | tar -xzv -C ~/.local/bin
chmod u+x ~/.local/bin/saml2aws
hash -r

echo '' >> ~/.profile
echo 'eval "$(saml2aws --completion-script-bash)"' >> ~/.profile

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
# we use 3.10 as default version for productive use
pyenv install 3.11.3
pyenv install 3.10.11
pyenv install 3.9.16
pyenv global 3.10.11

# install poetry
curl -sSL https://install.python-poetry.org | python3 -

# development directory structure
mkdir -p ~/docker-volumes
mkdir -p ~/workspace

# ensure systemd gets started, so that we can use snap to install software
sudo tee /etc/wsl.conf -a <<_EOF
[boot]
systemd=true
_EOF

echo '-------------------------------------------------------'
echo 'please restart your WSL2 to activate all changes'
echo '-------------------------------------------------------'