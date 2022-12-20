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



function InstallingRequiredtool {
echo -e "\e[1m\e[32mInstalling required tool ... \e[0m" && sleep 1
sudo apt install curl -y > /dev/null 2>&1
sudo apt update > /dev/null 2>&1 && apt install git sudo unzip wget -y > /dev/null 2>&1
sudo apt install curl tar wget vim clang pkg-config libssl-dev jq build-essential git make ncdu -y > /dev/null 2>&1
}


function InstallingGo {
echo " "
echo -e "\e[1m\e[32mInstalling Go ... \e[0m" && sleep 1
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
}


function Installingcelestia-app {
echo " "
echo -e "\e[1m\e[32mInstalling Celestia App ... \e[0m" && sleep 1
cd $HOME 
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app 
git checkout v0.11.0
make install
}


function Createwallet {
echo " "
echo -e "\e[1m\e[32mCreate Celestia Wallet ... \e[0m" && sleep 1
source ~/.bash_profile

read -p "Insert Metamask Address: " EVM && sleep 2
echo 'export EVM='$EVM >> $HOME/.bash_profile

if [ ! $CNODENAME ]; then
#read -p "Insert node name: " NODENAME && sleep 2
#echo 'export CNODENAME='$NODENAME >> $HOME/.bash_profile

while true; do
  read -p "Insert node name: " NODENAME
  if [[ $NODENAME =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export CNODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $CWALLET ]; then
while true; do
  read -p "Insert wallet name: " WALLET
  if [[ $WALLET =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export CWALLET='${WALLET} >> $HOME/.bash_profile
echo 'export ORWALLET='ORCHESTRATOR_${WALLET} >> $HOME/.bash_profile
fi

#if [ ! $ORCHESTRATORWALLET ]; then
#read -p "Insert ORCHESTRATOR Wallet name: " ORWALLET && sleep 2
#echo 'export ORWALLET='${ORWALLET} >> $HOME/.bash_profile
#fi

source $HOME/.bash_profile
celestia-appd config chain-id mocha
celestia-appd config keyring-backend test
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml
}



function SetchainID {
echo " "
echo -e "\e[1m\e[32mSet chain id mocha and keyring-backend test... \e[0m" && sleep 1
celestia-appd config keyring-backend test
celestia-appd config chain-id mocha
celestia-appd init ${CNODENAME} --chain-id mocha && sleep 2
}


function Setupgenesis  {
echo " "
echo -e "\e[1m\e[32mDownload Genesis.json... \e[0m" && sleep 1
cd $HOME/celestia-app
rm -rf networks
git clone https://github.com/celestiaorg/networks.git
cp $HOME/celestia-app/networks/mocha/genesis.json $HOME/.celestia-app/config
}



function Setseedsandpeers  {
echo " "
echo -e "\e[1m\e[32mSet seeds and peers... \e[0m" && sleep 1
#curl -Ls https://snapshots.kjnodes.com/celestia-testnet/addrbook.json > $HOME/.celestia-app/config/addrbook.json
curl -s https://snapshots3-testnet.nodejumper.io/celestia-testnet/addrbook.json > $HOME/.celestia-app/config/addrbook.json
#peers="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:20656,f9e950870eccdb40e2386896d7b6a7687a103c99@88.99.219.120:43656,c2870ce12cfb08c4ff66c9ad7c49533d2bd8d412@178.170.47.171:26656,8bb8e34ac6eb4ddb927bb1cbbd44357683123af1@188.165.221.155:30542,0d0f0e4a149b50a96207523a5408611dae2796b6@198.199.82.109:26656,eaa763cde89fcf5a8fe44274a5ee3ce24bce2c5b@64.227.18.169:26656"
#sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.celestia-app/config/config.toml
peers="e5fa03c0d18d1e51182a7d787fc25c3e57f03d7b@celestia-testnet.nodejumper.io:29656,4e409a7e4e7cd930a9cfb0a97f5b51b50cd70c86@65.21.199.148:26628,59ff849dd45e763a6b4f6ad33d38bb49e3bee735@65.108.233.109:11656,13a8bcd8c0487467518e577fcb9179c1027cd472@65.109.30.12:60556,eec289755259106bf29266c401bace003289c6be@35.234.94.146:26656,94b63fddfc78230f51aeb7ac34b9fb86bd042a77@[2a01:4f8:151:4009::2]:30549,cb0db7a1fb8897c8eec9b09285e39d1756ed87b7@65.109.88.254:26656,0d8b40858dcdf1e4370b2ed66b632bddf13a150d@75.119.143.147:26656,1d667e973e0dfcf0f92f7a202c241f5cfa6039cb@188.34.154.35:26656,40c52c800ec23c636a9e8f099ace910a836cab9f@212.90.121.160:656,1fc51f988cc618e0f00d6ae9710e90dd6755f418@65.21.132.27:11656,a4a4e43dd641f1b921f76a02154846968024f744@95.111.235.247:26656,e793a45d741f1dc0df7a6567dd8a1bcbdb9b1f0c@168.119.124.130:20656,5f7eeebf3d90344a6efeea95f8f260fe455b8096@46.4.23.42:36656,2cdbb3f9f9ac356bc6691322f58703e0a4595f5f@65.109.132.64:26656,51bb01af8537d7c76fe5e09f6f8bd3acefcdb486@65.109.108.152:29786,e8906342e657ace92e1ed8599f0949da8dd75fbd@146.19.24.52:20656,f1c53c3e03fdaa8a727c9b733464cf7e06c117e6@213.239.207.165:29786,79b838bc0084555949d813a1a0c51dcd6c9a2df3@65.108.235.238:26656,3247475e99137ea3a9158a07d3d898281f8c70e5@135.181.136.124:26656,c5acce2f30d380eba6480237e9c7ebee6a80e048@31.7.196.15:26656,112376a135c310172eec47fac2969992dc17ae43@70.34.197.18:26656,897e79c3208ac63ee8a494543d6a2c7e21f5a792@185.216.178.198:26656,cbb5cfdfb891b99df94c4a58585aa816b3b1a934@65.108.66.34:29786"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.celestia-app/config/config.toml
}


function Addnewpeer  {
echo " "
echo -e "\e[1m\e[32mAdd new peers... \e[0m" && sleep 1
sudo systemctl stop celestia-appd
peers="e5fa03c0d18d1e51182a7d787fc25c3e57f03d7b@celestia-testnet.nodejumper.io:29656,4e409a7e4e7cd930a9cfb0a97f5b51b50cd70c86@65.21.199.148:26628,59ff849dd45e763a6b4f6ad33d38bb49e3bee735@65.108.233.109:11656,13a8bcd8c0487467518e577fcb9179c1027cd472@65.109.30.12:60556,eec289755259106bf29266c401bace003289c6be@35.234.94.146:26656,94b63fddfc78230f51aeb7ac34b9fb86bd042a77@[2a01:4f8:151:4009::2]:30549,cb0db7a1fb8897c8eec9b09285e39d1756ed87b7@65.109.88.254:26656,0d8b40858dcdf1e4370b2ed66b632bddf13a150d@75.119.143.147:26656,1d667e973e0dfcf0f92f7a202c241f5cfa6039cb@188.34.154.35:26656,40c52c800ec23c636a9e8f099ace910a836cab9f@212.90.121.160:656,1fc51f988cc618e0f00d6ae9710e90dd6755f418@65.21.132.27:11656,a4a4e43dd641f1b921f76a02154846968024f744@95.111.235.247:26656,e793a45d741f1dc0df7a6567dd8a1bcbdb9b1f0c@168.119.124.130:20656,5f7eeebf3d90344a6efeea95f8f260fe455b8096@46.4.23.42:36656,2cdbb3f9f9ac356bc6691322f58703e0a4595f5f@65.109.132.64:26656,51bb01af8537d7c76fe5e09f6f8bd3acefcdb486@65.109.108.152:29786,e8906342e657ace92e1ed8599f0949da8dd75fbd@146.19.24.52:20656,f1c53c3e03fdaa8a727c9b733464cf7e06c117e6@213.239.207.165:29786,79b838bc0084555949d813a1a0c51dcd6c9a2df3@65.108.235.238:26656,3247475e99137ea3a9158a07d3d898281f8c70e5@135.181.136.124:26656,c5acce2f30d380eba6480237e9c7ebee6a80e048@31.7.196.15:26656,112376a135c310172eec47fac2969992dc17ae43@70.34.197.18:26656,897e79c3208ac63ee8a494543d6a2c7e21f5a792@185.216.178.198:26656,cbb5cfdfb891b99df94c4a58585aa816b3b1a934@65.108.66.34:29786"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.celestia-app/config/config.toml
sudo systemctl start celestia-appd 
}



function Setpruning {
echo " "
echo -e "\e[1m\e[32mSet Pruning... \e[0m" && sleep 1
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "10"|g' $HOME/.celestia-app/config/app.toml
}


function Recoverwallet {
echo " "
if [ ! $CNODENAME ]; then
while true; do
  read -p "Insert node name: " NODENAME
  if [[ $NODENAME =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export CNODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo " "

if [ ! $CWALLET ]; then
while true; do
  read -p "Insert wallet name: " WALLET
  if [[ $WALLET =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export CWALLET='${WALLET} >> $HOME/.bash_profile
echo 'export ORWALLET='ORCHESTRATOR_${WALLET} >> $HOME/.bash_profile
fi
echo " "

source $HOME/.bash_profile
celestia-appd config chain-id mocha
celestia-appd config keyring-backend test
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml

echo -e "\e[1m\e[31mPlease write you mnemonic phrase. \e[0m" && sleep 1
echo " "
source $HOME/.bash_profile && celestia-appd keys add $CWALLET --recover
echo " "
echo " "
echo " "
echo -e "\e[1m\e[32mCreate ORCHESTRATOR ADDRESS... \e[0m" && sleep 1
source $HOME/.bash_profile && celestia-appd keys add $ORWALLET
echo " "
echo " "
echo " "
read -p "Insert Metamask Address: " EVM && sleep 2
echo 'export EVM='$EVM >> $HOME/.bash_profile
echo -e "\e[1m\e[33mYour celestia Wallet address : $(celestia-appd keys show ${WALLET} -a)\e[0m" && sleep 1
echo -e "\e[1m\e[34mYour celestia Validator address : $(celestia-appd keys show ${WALLET} --bech val -a)\e[0m" && sleep 1    
echo -e "\e[1m\e[34mYour celestia ORCHESTRATOR address : $(celestia-appd keys show ${ORWALLET} -a)\e[0m" && sleep 1    
echo 'export CWALLET_ADDRESS='$(celestia-appd keys show ${CWALLET} -a) >> $HOME/.bash_profile
echo 'export CVALOPER_ADDRESS='$(celestia-appd keys show ${CWALLET} --bech val -a) >> $HOME/.bash_profile
echo 'export ORCHESTRATOR_ADDRES='$(celestia-appd keys show ${ORWALLET} -a) >> $HOME/.bash_profile

}


function Setsystemd {
echo " "
echo -e "\e[1m\e[32mCreate celestia-appd.service ... \e[0m" && sleep 1
sudo tee /etc/systemd/system/celestia-appd.service > /dev/null << EOF
[Unit]
Description=Celestia Validator Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which celestia-appd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable celestia-appd
}



function setP2PConfigurationOptions {
echo " "
echo -e "\e[1m\e[32mSet P2P Configuration Options... \e[0m" && sleep 1
use_legacy="false"
pex="true"
max_connections="90"
peer_gossip_sleep_duration="2ms"
sed -i.bak -e "s/^use-legacy *=.*/use-legacy = \"$use_legacy\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^pex *=.*/pex = \"$pex\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-connections *=.*/max-connections = \"$max_connections\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^peer-gossip-sleep-duration *=.*/peer-gossip-sleep-duration = \"$peer_gossip_sleep_duration\"/" $HOME/.celestia-app/config/config.toml
}

function Syncsnap {
echo " "
sudo systemctl stop celestia-appd && sleep 5

echo -e "\e[1m\e[32mDownload data from Lasted snap ... \e[0m" && sleep 1
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app --keep-addr-book && sleep 5
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mocha.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/
sudo systemctl restart celestia-appd
}


function Restart {
echo " "
echo -e "\e[1m\e[32mRestart you node ... \e[0m" && sleep 1
sudo systemctl restart celestia-appd
}


function Checksync {
echo " "
echo -e "\e[1m\e[32mCheck you node sync... \e[0m" && sleep 1
source $HOME/.bash_profile && celestia-appd status 2>&1 | jq .SyncInfo.latest_block_height
source $HOME/.bash_profile && celestia-appd status 2>&1 | jq .SyncInfo.catching_up
}

function Addwallet {
echo " "
echo -e "\e[1m\e[32mCreate you wallet... \e[0m" && sleep 1
echo -e "\e[1m\e[31m **Important** Please write this mnemonic phrase in a safe place. \e[0m" && sleep 1
echo " "
echo " "
echo -e "\e[1m\e[32mCreate WALLET ADDRESS... \e[0m" && sleep 1
source $HOME/.bash_profile && celestia-appd keys add $CWALLET
echo " "
echo " "
echo " "
echo -e "\e[1m\e[32mCreate ORCHESTRATOR ADDRESS... \e[0m" && sleep 1
source $HOME/.bash_profile && celestia-appd keys add $ORWALLET
echo " "
echo " "
echo " "
echo -e "\e[1m\e[33mYour celestia Wallet address : $(celestia-appd keys show ${CWALLET} -a)\e[0m" && sleep 1
echo -e "\e[1m\e[34mYour celestia Validator address : $(celestia-appd keys show ${CWALLET} --bech val -a)\e[0m" && sleep 1    
echo -e "\e[1m\e[34mYour celestia ORCHESTRATOR address : $(celestia-appd keys show ${ORWALLET} -a)\e[0m" && sleep 1    
echo 'export CWALLET_ADDRESS='$(celestia-appd keys show ${CWALLET} -a) >> $HOME/.bash_profile
echo 'export CVALOPER_ADDRESS='$(celestia-appd keys show ${CWALLET} --bech val -a) >> $HOME/.bash_profile
echo 'export ORCHESTRATOR_ADDRES='$(celestia-appd keys show ${ORWALLET} -a) >> $HOME/.bash_profile
}

function Checkbalances {
echo " "
echo -e "\e[1m\e[32mCheck you balance... \e[0m" && sleep 1
source $HOME/.bash_profile && celestia-appd query bank balances $CWALLET_ADDRESS
}


function CreateValidator {
echo " "
echo -e "\e[1m\e[32mCreate Validator ... \e[0m" && sleep 1 
source $HOME/.bash_profile && sleep 1 
celestia-appd tx staking create-validator \
--amount=9000000utia \
--pubkey=$(celestia-appd tendermint show-validator) \
--moniker=$CNODENAME \
--chain-id=mocha \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1000000 \
--from=$CWALLET_ADDRESS \
--keyring-backend=test \
--evm-address=$EVM \
--orchestrator-address=$ORCHESTRATOR_ADDRES \
--fees 5000utia \
--gas=auto \
--gas-adjustment 1.3 -y
  
sleep 10
  
#celestia-appd tx slashing unjail --from=$CWALLET_ADDRESS --chain-id=mocha --fees 1000utia --gas-adjustment=1.4 --gas=auto -y
#echo -e "\e[1m\e[34mYour Celestia Validator address : $(celestia-appd keys show ${CWALLET} --bech val -a)\e[0m" && sleep 1
}


function Delegate {
echo " "
echo -e "\e[1m\e[32mDelegate Token to you validator ... \e[0m" && sleep 1
YBalance=$(source $HOME/.bash_profile && celestia-appd query bank balances $CWALLET_ADDRESS  |grep amount |awk -F"\"" '{print $2}')
echo "You utia Balance $YBalance"
echo -e "\e[1m\e[34mYou utia Balance : ${YBalance}\e[0m" && sleep 1
echo " "
echo " "
#read -p "Insert utia need Delegate : " ToDelegate && sleep 2
CanDelegate=$((YBalance - 2000000))
source $HOME/.bash_profile && celestia-appd tx staking delegate $CVALOPER_ADDRESS ${CanDelegate}utia --from=$CWALLET_ADDRESS --chain-id=mocha --fees 5000utia --gas 1000000 --gas-adjustment 1.3 -y
}


function Delete {
echo " "
echo -e "\e[1m\e[32mDelete you node ... \e[0m" && sleep 1
sudo systemctl stop celestia-appd && sudo systemctl disable celestia-appd && sudo rm /etc/systemd/system/celestia-appd.service && sudo systemctl daemon-reload && rm -rf $HOME/.celestia-app && rm -rf $HOME/celestia-app  && rm $(which celestia-appd) 
sudo sed -i '/CWALLET/d' $HOME/.bash_profile
sudo sed -i '/CWALLET_ADDRESS/d' $HOME/.bash_profile
sudo sed -i '/CVALOPER_ADDRESS/d' $HOME/.bash_profile
sudo sed -i '/CNODENAME/d' $HOME/.bash_profile
sudo sed -i '/EVM/d' $HOME/.bash_profile
sudo sed -i '/ORCHESTRATOR_ADDRES/d' $HOME/.bash_profile
sudo sed -i '/ORWALLET/d' $HOME/.bash_profile
sudo sed -i '/NODENAME/d' $HOME/.bash_profile
sudo sed -i '/WALLET/d' $HOME/.bash_profile
sudo sed -i '/WALLET_ADDRESS/d' $HOME/.bash_profile
sudo sed -i '/VALOPER_ADDRESS/d' $HOME/.bash_profile
}






PS3='Please enter your choice (input your option number and press enter): '
options=("Install" "Install + Snap" "Install + Snap with old wallet" "Check Sync" "Snapshort" "Check Balance" "Create Validator" "Restart" "Delegate" "Uninstall" "Add Peer" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Install")
            echo -e '\e[1m\e[32mYou choose Install without Snapshort ...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
Installingcelestia-app
Createwallet
SetchainID
Setupgenesis
Setseedsandpeers
Setpruning
Setsystemd
setP2PConfigurationOptions
Restart
Addwallet
echo -e "\e[1m\e[32mYour Node was Install!\e[0m" && sleep 1
break
;;

"Install + Snap")
            echo -e '\e[1m\e[32mYou choose Install with Snapshort ...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
Installingcelestia-app
Createwallet
SetchainID
Setupgenesis
Setseedsandpeers
Setpruning
Setsystemd
setP2PConfigurationOptions
Syncsnap
Restart
Addwallet
echo -e "\e[1m\e[32mYour Node was Install!\e[0m" && sleep 1

;;

"Install + Snap with old wallet")
            echo -e '\e[1m\e[32mYou choose Install with Snapshort ...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
Installingcelestia-app
Recoverwallet
#Createwallet
SetchainID
Setupgenesis
Setseedsandpeers
Setpruning
Setsystemd
setP2PConfigurationOptions
Syncsnap
Restart
echo -e "\e[1m\e[32mYour Node was Install!\e[0m" && sleep 1

;;

"Check Sync")
            echo -e '\e[1m\e[32mYou choose Check Sync ...\e[0m' && sleep 1
Checksync

;;

"Check Balance")
            echo -e '\e[1m\e[32mYou choose Check Balance ...\e[0m' && sleep 1
Checkbalances

;;

"Snapshort")
            echo -e '\e[1m\e[32mYou choose Download Snapshot ...\e[0m' && sleep 1
Syncsnap
echo -e "\e[1m\e[32mDownload Snapshot complete!\e[0m" && sleep 1


;;


"Create Validator")
echo -e '\e[1m\e[32mYou choose Create Validator ...\e[0m' && sleep 1
CreateValidator
echo -e "\e[1m\e[34mYour Celestia Validator address : $(celestia-appd keys show ${CWALLET} --bech val -a)\e[0m" && sleep 1

;;

"Restart")
echo -e '\e[1m\e[32mYou choose Restart You Node ...\e[0m' && sleep 1
Restart
echo -e "\e[1m\e[32mRestart You Node complete!\e[0m" && sleep 1


;;

"Delegate")
echo -e '\e[1m\e[32mYou choose Delegate ...\e[0m' && sleep 1
Delegate
echo -e "\e[1m\e[32mDelegate Complete!\e[0m" && sleep 1

;;

"Uninstall")
echo -e '\e[1m\e[32mYou choose Uninstall ...\e[0m' && sleep 1
Delete
echo -e "\e[1m\e[32mYour Node was Uninstall complete!\e[0m" && sleep 1
break
;;

"Add Peer")
echo -e '\e[1m\e[32mYou choose Add new Peer...\e[0m' && sleep 1
Addnewpeer
echo -e "\e[1m\e[32mYour Node was  Add new Peer complete!\e[0m" && sleep 1
break
;;

"Quit")
break
;;

*) echo -e "\e[91minvalid option $REPLY\e[0m";;
    esac
done
