#!/bin/bash
# workaround to enable WSL interop functionality after enabling systemd
# ensure systemd is already enabled and required packages are created with wsl_install_software.sh
# provided by: tuteco GmbH - the data and knowledge experts

# taken from https://github.com/microsoft/WSL/issues/8843
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'

# taken from https://github.com/microsoft/WSL/issues/7181
sudo apt-get reinstall binfmt-support
sudo update-binfmts --enable

echo '-------------------------------------------------------'
echo 'please restart your WSL2 to activate all changes'
echo '-------------------------------------------------------'