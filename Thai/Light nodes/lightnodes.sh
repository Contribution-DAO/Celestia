#!/bin/bash

echo -e "\e[1m\e[32mInstalling required tool ... \e[0m" && sleep 1
sudo apt install curl -y > /dev/null 2>&1
sudo apt update > /dev/null 2>&1 && apt install git sudo unzip wget -y > /dev/null 2>&1
sudo apt install curl tar wget vim clang pkg-config libssl-dev jq build-essential git make ncdu -y > /dev/null 2>&1



echo -e "\e[1m\e[32mInstalling Go ... \e[0m" && sleep 1
ver="1.19.1"
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
# Semantic version: v0.6.4
# Commit: 747c9e593542dfb32a933c731a9cd74b1fab897f
# Build Date: Thu Feb 16 02:06:59 AM CST 2023
# System version: amd64/linux
# Golang version: go1.19.1

echo " "
echo -e "\e[1m\e[32mSet Initialize the light node... \e[0m" && sleep 1
celestia light init



echo " "
echo -e "\e[1m\e[32mAdd live peers... \e[0m" && sleep 1
peers="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:20656,e286b562eddc6fea1b2635f6623430225666fb2f@147.135.144.58:26656,3ad7f2d36f5e15d902c7aff7a305bea40f03f95c@163.172.111.148:26656,6a03b088a9e183e7faa897afcc6b50c6971a4cd5@159.69.5.164:26656,2c93920515e53e0e08ca4bc86dd76a194ee34a29@89.117.59.233:26656,0d8b40858dcdf1e4370b2ed66b632bddf13a150d@75.119.143.147:26656,c1c0813668f8e67237f09cf9f57af802a0dc2f93@168.119.226.107:26756"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.celestia-light-mocha/config.toml

echo " "
echo -e "\e[1m\e[32mCreate celestia-appd.service ... \e[0m" && sleep 1
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
[Unit]
Description=celestia-lightd Light Node
After=network-online.target
 
[Service]
User=$USER
ExecStart=celestia light start --core.ip https://grpc-blockspacerace.pops.one/ --keyring.accname my_celes_key --gateway --gateway.addr localhost --gateway.port 26659 --p2p.network blockspacerace --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
 
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-lightd
sudo systemctl start celestia-lightd


echo " "
echo " "
echo -e "\e[1m\e[32mCreate Keys and wallets ... \e[0m" && sleep 1
cd $HOME/celestia-node/ 
while true; do
read -p "Insert key name: " key_name
if [[ $key_name =~ ^[a-zA-Z0-9]+$ ]]; then
break
else
echo "Error: Please enter only text and numbers."
fi
done
./cel-key add $key_name --keyring-backend test --node.type light --p2p.network mocha
