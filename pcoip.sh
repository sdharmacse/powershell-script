



### Install Docker  
sudo dnf install -y dnf-utils
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io

sudo service docker restart

## Download Package 
#The command fetches a configuration script from our servers and runs it locally, setting up and configuring the repository on the local machine.

curl -1sLf https://dl.teradici.com/C26enr8Soe58TV67/pcoip-cmsg/cfg/setup/bash.rpm.sh | sudo -E bash

sudo dnf install -y pcoip-cmsg-setup

sudo pcoip-cmsg-setup install ‑‑enable-security-gateway --self-signed --broker-url $1 --accept-policies   --external-pcoip-ip stringArray $2 --ignore-disk-req
