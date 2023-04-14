# WSL2-setup 
Get ready with Windows WSL2 for python development. The setup prepares you for local development with Docker and working in AWS.
We mainly work with JetBrains PyCharm Professional, but you can also use this setup if you want to work with VS Code

The following setup is tested with
- Windows 11 Pro ( Version 22H2 )
- WSL2 feature enabled
- VS Code 1.77
- PyCharm Professional 2023.1
- Docker Desktop 4.18.0

If you have other versions than the ones mentioned above, you might encounter different outcomes or run into issues. 
In case of any questions or suggestions, please open up an issue here.

Task that we will accomplish during this setup 
- set up a default instance with Ubuntu 22.04 LTS
- install software packages required for modern python development: [pyenv](https://github.com/pyenv/pyenv) 
  and [poetry](https://python-poetry.org/docs)
- configure ssh agent to load your certificates automatically
- ensure AWS client is configured and authentication with saml2aws works
- set up a second WSL2 instance with the latest Ubuntu 23.04
- remove a WSL2 instance

## adding a default distro

The WSL2 instance, that we will install first, will become your default
distro. We use Ubuntu, currently version 22.04 LTS. Later, we will install a second one with the latest version of Ubuntu. 

Open a PowerShell and
- check the status of installed distros
- list the available distros online
- install the Ubuntu distro, currently version 22.04 LTS

```
wsl -l -v  # list the locally installed images
wsl --list --online  # list all available images
wsl --install -d Ubuntu  
```

The Ubuntu WSL will start to ask for the username and password you want to use inside the Ubuntu distro

Make the Ubuntu WSL the default with
```
wsl --setdefault Ubuntu
```

## Install required linux packages

To install all the required software packages, just run the following command:
```
curl https://raw.githubusercontent.com/tuteco/wsl-setup/main/wsl_install_software.sh | bash
```

## SSH config for git

After the installation script has run, you need to configure the ssh client.

Add your private certificate(s) to connect to git to the .ssh directory. You can copy them from your windows host with the explorer. To access the .ssh folder, add the following path to the explorer address bar
```
\\wsl$\Ubuntu\home\<username>\.ssh

```
Replace the <username> with the username you specified during WSL installation of the Ubuntu distro
  
Ensure the access rights are correct on your certificate
```
sudo chown <username>:<username> –/.ssh/<certificate-file-name>
chmod 400 –/.ssh/<certificate-file-name>
```

Finally, add the certificate to the `–/.profile` file. 
Search for the string `# ssh-add ~/.ssh/<certificate-file-name>`. 
Uncomment the line and replace <certificate-file-name> with the filename of your certificate.

For all changes to take effect, you need to restart your instance

## Restart the WSL2 instance 
There are situations, where you want or have to restart your WSL2 instance. Here is what you need to do starting from a PowerShell terminal
- check the current status
- stop the WSL2 instance
- test if it stopped
- start the WSL2 instance

```
$WSL2_INSTANCE="UBUNTU"
wsl -l -v
wsl --terminate $WSL2_INSTANCE
wsl -l -v
wsl -d $WSL2_INSTANCE
```

## Configure AWS CLI and saml2aws
tbd

## Set up a second distro
inspired by https://cloudbytes.dev/snippets/how-to-install-multiple-instances-of-ubuntu-in-wsl2
and updated to the latest Version of Ubuntu

```
Remove-Item alias:curl
mkdir ~\wsl2
cd ~\Downloads
curl "https://cloud-images.ubuntu.com/wsl/lunar/current/ubuntu-lunar-wsl-amd64-wsl.rootfs.tar.gz" --output ubuntu-23.04-wsl-rootfs.tar.gz
$WSL2_INSTANCE="ubuntu-2304-dev1"
wsl --import $WSL2_INSTANCE "~\wsl2\$WSL2_INSTANCE" .\ubuntu-23.04-wsl-rootfs.tar.gz
wsl -d $WSL2_INSTANCE
```

The last command started your second WSL2 instance. Now you can create your user, set the password and ensure that you are automatically logged in.
All commands are executed inside the WSL instance. 

Please replace <USERNAME> with your own username.

```
NEW_USER=<USERNAME>
```
```
useradd -m -G sudo -s /bin/bash "$NEW_USER"
passwd "$NEW_USER"
```
To ensure your user is loggin in by default insead of roo, execute the following command in the WSL instance:
```
tee /etc/wsl.conf <<_EOF
[user]
default=${NEW_USER}
_EOF
```

You need to restart your WSL instance to activate the change. 
Once you are successfully logged in, you can proceed with 
- Install required linux packages
- SSH config for git
- Configure AWS CLI and saml2aws

## Remove a WSL instance
tbd



