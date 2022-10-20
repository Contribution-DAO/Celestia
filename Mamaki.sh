#!/bin/bash
echo -e "\033[0;33m"
echo "==========================================================================================================================="
echo " "
echo "  ██████╗ ██████╗ ███╗   ██╗████████╗██████╗ ██╗██████╗ ██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗██████╗  █████╗  ██████╗ ";
echo " ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██║██╔══██╗██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗";
echo " ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║██████╔╝██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║██║  ██║███████║██║   ██║";
echo " ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║██╔══██╗██║   ██║   ██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║██║   ██║";
echo " ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║██████╔╝╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║╚██████╔╝";
echo "  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ";
                                                                                                                                                                                                 
echo -e "\033[0;33m"
echo "==========================================================================================================================="                                                                                    
sleep 1



#function Updatingpackages 
echo -e "\e[1m\e[32mInstalling required tool \e[0m" && sleep 1
sudo apt update && apt install git sudo unzip wget -y < "/dev/null"



#function Installingdependencies 
echo -e "\e[1m\e[32mInstalling dependencies \e[0m" && sleep 1
sudo apt install curl tar wget vim clang pkg-config libssl-dev jq build-essential git make ncdu -y < "/dev/null"


#function Installinggo 
echo -e "\e[1m\e[32mInstalling GO \e[0m" && sleep 1
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version



#function Installingcelestia 
echo -e "\e[1m\e[32mInstalling Celestia \e[0m" && sleep 1
cd $HOME
sudo rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app
#APP_VERSION=$(curl -s https://api.github.com/repos/celestiaorg/celestia-app/releases/latest | jq -r ".tag_name")
#git checkout tags/$APP_VERSION -b $APP_VERSION
git checkout v0.6.0
make install


#function setupp2pnetworks 
echo -e "\e[1m\e[32mSetup P2P Network \e[0m" && sleep 1
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git


#function setupconfig 
# set vars
echo -e "\e[1m\e[32mSetup Node & Wallet \e[0m" && sleep 1
if [ ! $nodename ]; then
read -p "Insert node name: " nodename && sleep 2
echo 'export NODENAME='${nodename} >> $HOME/.bash_profile
fi
celestia-appd init ${nodename} --chain-id mamaki && sleep 2


if [ ! $walletname ]; then
read -p "Insert wallet name: " walletname && sleep 2
echo 'export WALLET='${walletname} >> $HOME/.bash_profile
fi
source $HOME/.bash_profile
celestia-appd config chain-id mamaki
celestia-appd config keyring-backend test




#function setupgenesis 
echo -e "\e[1m\e[32mSetup genesis config \e[0m" && sleep 1
#wget -qO $HOME/.celestia-app/config/genesis.json https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/genesis.json
cp $HOME/networks/mamaki/genesis.json $HOME/.celestia-app/config




#function setseedsandpeers 
echo -e "\e[1m\e[32mSet seeds and peers  \e[0m" && sleep 1
curl -s https://rpc-mamaki.pops.one/net_info | jq -r '.result.peers[] | .url'  > $HOME/.celestia-app/config/bootstrap-peers.txt
sed -i s/$/,/ $HOME/.celestia-app/config/bootstrap-peers.txt
BOOTSTRAP_PEERS=$(cat $HOME/.celestia-app/config/bootstrap-peers.txt | tr -d '\n' | sed '$ s/.$//')
#BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
MY_PEER=$(celestia-appd tendermint show-node-id)@$(curl -s ifconfig.me)$(grep -A 9 "\[p2p\]" ~/.celestia-app/config/config.toml | egrep -o ":[0-9]+")
PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/peers.txt | tr -d '\n' | head -c -1 | sed s/"$MY_PEER"// | sed "s/,,/,/g")
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^persistent-peers *=.*/persistent-peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml


#function setP2PConfigurationOptions
use_legacy="false"
pex="true"
max_connections="45"
max_num_inbound_peers=0
max_num_outbound_peers=0
peer_gossip_sleep_duration="2ms"

sed -i.bak -e "s/^use-legacy *=.*/use-legacy = \"$use_legacy\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^pex *=.*/pex = \"$pex\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-num-inbound-peers *=.*/max-num-inbound-peers = $max_num_inbound_peers/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-num-outbound-peers *=.*/max-num-outbound-peers = $max_num_outbound_peers/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-connections *=.*/max-connections = \"$max_connections\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^peer-gossip-sleep-duration *=.*/peer-gossip-sleep-duration = \"$peer_gossip_sleep_duration\"/" $HOME/.celestia-app/config/config.toml




#function configpruning
echo -e "\e[1m\e[32mConfig pruning \e[0m" && sleep 1
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="5000"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.celestia-app/config/app.toml

sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.celestia-app/config/config.toml


#function setvalidatormode
echo -e "\e[1m\e[32mSet validator node  \e[0m" && sleep 1
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml

#function quickSync 
echo -e "\e[1m\e[32mDownload QuickSync  \e[0m" && sleep 1
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - -C ~/.celestia-app/data/


#function createservice 
echo -e "\e[1m\e[32mSet service  \e[0m" && sleep 1
tee $HOME/celestia-appd.service > /dev/null <<EOF
[Unit]
Description=celestia-appd
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which celestia-appd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/celestia-appd.service /etc/systemd/system/


#function startservice 
echo -e "\e[1m\e[32mStart service  \e[0m" && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable celestia-appd
sudo systemctl restart celestia-appd

echo "==========================================================================================================================="        
echo " "

echo "==========================================================================================================================="     


echo -e '\e[32mCheck your celestia fullnode status\e[39m' && sleep 3
if [[ `service celestia-appd status | grep active` =~ "running" ]]; then
  echo -e "Your celestia fullnode \e[32minstalled and running normally\e[39m!"
else
  echo -e "Your celestia fullnode \e[31mwas failed installed\e[39m, Please Re-install."
fi

echo " "

echo "==========================================================================================================================="     

#function setupwallet 
echo -e "\e[1m\e[32mSetup Wallet \e[0m" && sleep 1
echo -e "\e[1m\e[31m **Important** Please write this mnemonic phrase in a safe place. \e[0m" && sleep 1
celestia-appd keys add $WALLET
echo " "
echo "==========================================================================================================================="        
echo " "

echo -e "\e[1m\e[33mYour celestia Wallet address : $(celestia-appd keys show ${WALLET} -a)\e[0m" && sleep 1
echo -e "\e[1m\e[34mYour celestia Validator address : $(celestia-appd keys show ${WALLET} --bech val -a)\e[0m" && sleep 1

echo " "
echo "==========================================================================================================================="        
echo 'export WALLET_ADDRESS='$(celestia-appd keys show ${WALLET} -a) >> $HOME/.bash_profile
echo 'export VALOPER_ADDRESS='$(celestia-appd keys show ${WALLET} --bech val -a) >> $HOME/.bash_profile
source $HOME/.bash_profile


