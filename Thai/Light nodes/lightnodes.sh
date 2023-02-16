#!/bin/bash

echo -e "\e[1m\e[32mInstalling required tool ... \e[0m" && sleep 1
sudo apt install curl -y > /dev/null 2>&1
sudo apt update > /dev/null 2>&1 && apt install git sudo unzip wget -y > /dev/null 2>&1
sudo apt install curl tar wget vim clang pkg-config libssl-dev jq build-essential git make ncdu -y > /dev/null 2>&1



echo -e "\e[1m\e[32mInstalling Go ... \e[0m" && sleep 1
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

echo " "
echo -e "\e[1m\e[32mInstalling Celestia App ... \e[0m" && sleep 1
cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.6.4 
make install 
make cel-key 

# Check version
celestia version
# OUTPUT
# v0.6.4

echo " "
echo -e "\e[1m\e[32mSet Initialize the light node... \e[0m" && sleep 1
celestia light init


echo -e "\e[1m\e[32mCreate celestia-appd.service ... \e[0m" && sleep 1
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
[Unit]
Description=celestia-lightd Light Node
After=network-online.target
 
[Service]
User=$USER
ExecStart=$HOME/go/bin/celestia light start --core.ip https://grpc-mocha.pops.one/ --core.grpc.port 9090 --gateway --gateway.addr localhost --gateway.port 26659 --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
 
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-lightd
sudo systemctl start celestia-lightd
