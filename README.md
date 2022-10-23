# wsl-setup
Get ready with Windows WSL for python development

Open a Powershell as administrator and
- check the status of installed ditros
- list the available distros online
- install the Ubuntu distro
- set the installed Ubuntu distro as default

```
wsl -l -v  # list the locally installed images
wsl --list --online  # list all available images
wsl --install -d Ubuntu  
wsl --setdefault Ubuntu
```

Go to your start menu and search for the Ubuntu Porgram. It will start the WSL. During the first start, you will be asked for 
the username and password you want to use inside the Ubuntu distro

To install all required software, just run the following command:
```
curl https://raw.githubusercontent.com/tuteco/wsl-setup/main/wsl_install_software.sh | bash
```

