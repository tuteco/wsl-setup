# wsl-setup
Get ready with Windows WSL for python development

Open a Powershell and
- check the status of installed ditros
- list the available distros online
- install the Ubuntu distro

```
wsl -l -v  # list the locally installed images
wsl --list --online  # list all available images
wsl --install -d Ubuntu  
```

The Ubuntu WSL will start ask for the username and password you want to use inside the Ubuntu distro

Make the Ubuntu WSL the default with
```
wsl --setdefault Ubuntu
```

To install all required software, just run the following command:
```
curl https://raw.githubusercontent.com/tuteco/wsl-setup/main/wsl_install_software.sh | bash
```

## ssh config for git

After the installation script has run, you need to configure the ssh client.

Add your private certificate(s) to connect to git to the `.ssh` directory. you can copy them from your windows host with the explorer. 
To access the `.ssh`folder, add the followinh path to the exploerer adress bar:
```
\\wsl$\Ubuntu\home\<username>\.ssh

```
Replace the <username> with the username you specified during WSL installation of the Ubuntu distro
  
Ensure the access rights are correct on your certificate
```
sudo chown <username>:<username> –/.ssh/<certificate-file-name>
chmod 400 –/.ssh/<certificate-file-name>
```

Finally add the certificate to the `–/.profile` file. 
Search for the string `# ssh-add ~/.ssh/<certificate-file-name>`. 
Uncomment the line and replace <certificate-file-name> with the filename of your certificate.
  
close the WSL terminal and repoen it.
