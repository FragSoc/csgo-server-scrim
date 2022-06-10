#!/bin/sh
set -eux

# Install Docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo docker --version

# Install Docker-Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Configure passwords
# sed -i 's/hostname "UoY Esports"/hostname "UoY Esports #1"/g' ~/cs_server_1/custom_server_template.cfg
# sed -i 's/sv_password "default"/sv_password "z6gMtKvm"/g' ~/cs_server_1/custom_server_template.cfg
# sed -i 's/rcon_password "default"/rcon_password "6zzPYFwQ"/g' ~/cs_server_1/custom_server_template.cfg

# sed -i 's/hostname "UoY Esports"/hostname "UoY Esports #2"/g' ~/cs_server_2/custom_server_template.cfg
# sed -i 's/sv_password "default"/sv_password "mLMQ7LgM"/g' ~/cs_server_2/custom_server_template.cfg
# sed -i 's/rcon_password "default"/rcon_password "zuKUW8wR"/g' ~/cs_server_2/custom_server_template.cfg

# Make install directories
install -m 0777 -d ./csgo-data1
install -m 0777 -d ./csgo-data2

# Run container composes
sudo docker-compose up -d
