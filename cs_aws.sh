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

# Clone repo locally
mkdir ~/cs_server_1/
git clone https://github.com/FragSoc/csgo-server-scrim.git ~/cs_server_1/.
mkdir ~/cs_server_2/
git clone https://github.com/FragSoc/csgo-server-scrim.git ~/cs_server_2/.

# Configure ports and source tokens
sed -i 's/SRCDS_TOKEN=309E76122D3C7522154AC7513C51984E/SRCDS_TOKEN=3C1836105A719D05E6E2377A823F66E1/g' ~/cs_server_1/docker-compose.yml

sed -i 's/SRCDS_TOKEN=309E76122D3C7522154AC7513C51984E/SRCDS_TOKEN=5BA590C6B96839FC248667027F2E8D79/g' ~/cs_server_2/docker-compose.yml
sed -i 's/SRCDS_PORT=27015/SRCDS_PORT=27016/g' ~/cs_server_2/docker-compose.yml
sed -i 's/SRCDS_TV_PORT=27020/SRCDS_TV_PORT=27021/g' ~/cs_server_2/docker-compose.yml

# Configure passwords
sed -i 's/hostname "UoY Esports"/hostname "UoY Esports #1"/g' ~/cs_server_1/custom_server_template.cfg
sed -i 's/sv_password "default"/sv_password "z6gMtKvm"/g' ~/cs_server_1/custom_server_template.cfg
sed -i 's/rcon_password "default"/rcon_password "6zzPYFwQ"/g' ~/cs_server_1/custom_server_template.cfg

sed -i 's/hostname "UoY Esports"/hostname "UoY Esports #2"/g' ~/cs_server_2/custom_server_template.cfg
sed -i 's/sv_password "default"/sv_password "mLMQ7LgM"/g' ~/cs_server_2/custom_server_template.cfg
sed -i 's/rcon_password "default"/rcon_password "zuKUW8wR"/g' ~/cs_server_2/custom_server_template.cfg

# Make install directory
mkdir ~/cs_server_1/csgo-data
chmod 777 ~/cs_server_1/csgo-data
mkdir ~/cs_server_2/csgo-data
chmod 777 ~/cs_server_2/csgo-data

# Run container composes
sudo docker-compose -f ~/cs_server_1/docker-compose.yml up -d
sudo docker-compose -f ~/cs_server_2/docker-compose.yml up -d


# rsync -av csgo-server-scrim/ csgo-server-scrim_2/


