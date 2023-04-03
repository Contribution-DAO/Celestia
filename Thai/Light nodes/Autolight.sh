#!/bin/bash

function InstallingRequiredtool {
        echo -e "\e[1m\e[32mInstalling required tool ... \e[0m" && sleep 1
        sudo apt install curl -y > /dev/null 2>&1
        sudo apt update > /dev/null 2>&1 && apt install git sudo unzip wget -y > /dev/null 2>&1
        sudo apt install curl tar wget vim clang pkg-config libssl-dev jq build-essential git make ncdu -y > /dev/null 2>&1
}



function InstallingGo {
        echo " "
        echo -e "\e[1m\e[32mInstalling Go ... \e[0m" && sleep 1
        ver="1.20"
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
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.8.1
make build 
make install 
make cel-key 
}


function Init {
        echo " "
        echo -e "\e[1m\e[32mInit Create... \e[0m" && sleep 1
        celestia light init --p2p.network blockspacerace
}



function CreateService {
        echo " "
        echo -e "\e[1m\e[32mCreate celestia-appd.service ... \e[0m" && sleep 1
        sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
        [Unit]
        Description=celestia-lightd Light Node
        After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia light start --core.ip https://rpc-blockspacerace.pops.one --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318 --gateway --gateway.addr localhost --gateway.port 26659 --p2p.network blockspacerace
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

systemctl enable celestia-lightd
systemctl start celestia-lightd
}

function Restart {
        echo " "
        echo -e "\e[1m\e[32mRestart you node ... \e[0m" && sleep 1
        sudo systemctl restart celestia-lightd
}


function NodeID {
        echo " "
        echo -e "\e[1m\e[32myou node ID is ... \e[0m" && sleep 1
        AUTH_TOKEN=$(celestia light auth admin --p2p.network blockspacerace)
curl -s -X POST      -H "Authorization: Bearer $AUTH_TOKEN"      -H 'Content-Type: application/json'      -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}'      http://localhost:26658 | jq .result.ID
}



function Getwallet {
        echo " "
        echo -e "\e[1m\e[32mList you wallet... \e[0m" && sleep 1
        ./cel-key list --node.type light --keyring-backend test --p2p.network blockspacerace
}





echo -e "\e[1m\e[32mMenu V1.2 \e[0m" && sleep 1

PS3='Please enter your choice (input your option number and press enter): '
options=("Install" "Get Wallet" "Get Node ID" "Restart" "Uninstall" "Quit")



select opt in "${options[@]}"
do
            case $opt in
"Install")
echo -e '\e[1m\e[32mYou choose Install...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
Installingcelestia-app
CreateService
echo -e "\e[1m\e[32mYour Node was Install!\e[0m" && sleep 1
#break
;;


"Get Node ID")
echo -e '\e[1m\e[32mYou choose Get Node ID...\e[0m' && sleep 1
NodeID
      
#break
;;


"Get Wallet")
echo -e '\e[1m\e[32mYou choose Get Wallet...\e[0m' && sleep 1
echo -e "\e[1m\e[31mPlease write you mnemonic phrase. \e[0m" && sleep 1
Init

#break
;;


"Restart")
echo -e '\e[1m\e[32mYou choose Restart...\e[0m' && sleep 1
Restart
echo -e "\e[1m\e[32mYour Node was Restart complete!\e[0m" && sleep 1
#break
;;


"Uninstall")
echo -e '\e[1m\e[32mYou choose Uninstall ...\e[0m' && sleep 1
sudo systemctl stop celestia-lightd && sudo systemctl disable celestia-lightd && sudo rm /etc/systemd/system/celestia-lightd.service && sudo systemctl daemon-reload && rm -rf $HOME/.celestia-light-blockspacerace-0 && rm -rf $HOME/celestia-node
echo -e "\e[1m\e[32mYour Node was Uninstall complete!\e[0m" && sleep 1
break
;;

"Quit")
break
;;

*) echo -e "\e[91minvalid option $REPLY\e[0m";;
    esac
done
