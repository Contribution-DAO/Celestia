# Setting Up A Celestia Validator Node 

## Hardware Requirements
The following hardware minimum requirements are recommended for running the validator node:

>:black_square_button:  OS Ubuntu 18.04 - 22.04<br> 
>:black_square_button:Memory: 8 GB RAM<br> 
>:black_square_button:CPU: Quad-Core<br> 
>:black_square_button:Disk: 250 GB SSD Storage<br> 
>:black_square_button:Bandwidth: 1 Gbps for Download/100 Mbps for Upload<br> 
>:black_square_button:TCP Port: 26656,26657,26660,9090<br>


## 0. Log on to root user

```

sudo su
```


## 1. Setup Validator Node

```

wget -q -O Mamaki.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Mamaki.sh && chmod +x Mamaki.sh && sudo /bin/bash Mamaki.sh
```

Node Name and Wallet Name plese use english letters and number only

## 2. (OPTIONAL) Setup Bridge Node

```

wget -q -O Bridge_Node.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Bridge_Node.sh && chmod +x Bridge_Node.sh && sudo /bin/bash Bridge_Node.sh
```

## 3. Check Syncing latest blocks

Make sure your validator is syncing latest blocks. 
You can use command below to check synchronization latest blocks and status sync.

### Wait sync time 1-3 hr.



```
source $HOME/.bash_profile && celestia-appd status 2>&1 | jq .SyncInfo
```

The result should be something like this: 



```json

  "latest_block_hash": "348246EB28F58BD98A6FD393FCA192E5AD960F04311850E236FDE9F08332F44D",
  "latest_app_hash": "B374929346A19C17EC9DFFA9DDB355448B0F1F050BA0830B7110A4B1E18CD5CE",
  "latest_block_height": "155777",
  "latest_block_time": "2022-07-30T21:43:25.070041966Z",
  "earliest_block_hash": "41BBFD05779719E826C4D68C4CCBBC84B2B761EB52BC04CFDE0FF8603C9AA3CA",
  "earliest_app_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
  "earliest_block_height": "1",
  "earliest_block_time": "2022-05-24T13:02:31.713132226Z",
  "max_peer_block_height": "155743",
  "catching_up": false,
  "total_synced_time": "0",
  "remaining_time": "0",
  "total_snapshots": "0",
  "chunk_process_avg_time": "0",
  "snapshot_height": "0",
  "snapshot_chunks_count": "0",
  "snapshot_chunks_total": "0",
  "backfilled_blocks": "0",
  "backfill_blocks_total": "0"

```
check ```last block height``` equal last block height on https://celestia.explorers.guru/ and ```catching_up = false```

![image](https://user-images.githubusercontent.com/83507970/182002293-aad8514b-ff0b-435e-8a3a-7e0998ba9bf5.png)


### ** If your node doesn't sync, Please restart your node with the command
```
sudo systemctl restart celestia-appd
```


## 4. Faucet testnet tokens

After your validator sync complete, You need Faucet testnet tokens on [Celestia discord](https://discord.gg/7uAkDSZrbH):
1) navigate to `#🚰｜faucet ` channel
2) post your celstia  wallet address in format 
```
$request <YOUR_WALLET_ADDRESS>
```




## 5. Verify your balance

Verify your balance on wallet with command
```
source $HOME/.bash_profile && celestia-appd query bank balances $WALLET_ADDRESS
```

The result should be something like this: 

```json
balances:
- amount: "1000000"
  denom: celes
pagination:
  next_key: null
  total: "0"
  ```


## 6. Connect Validator
Make sure balance on wallet before  run Validator command

```

wget -q -O Create-validator.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Create-validator.sh && chmod +x Create-validator.sh && sudo /bin/bash Create-validator.sh
```

## 7. Verify your Validator
Go to https://celestia.explorers.guru and insert your VALOPER_ADDRESS , Press enter for check

![image](https://user-images.githubusercontent.com/83507970/182002233-667be61c-74a1-4a41-bdbb-d3a46747e441.png)




## 8. Usefull commands

Stop node
```
sudo systemctl stop celestia-appd
```


Start node
```
sudo systemctl start celestia-appd
```


Restart node
```
sudo systemctl restart celestia-appd
```

Monitor logs
```
journalctl -fu celestia-appd -o cat
```


Show wallet details
```
source $HOME/.bash_profile && celestia-appd keys list
```

Show wallet address
```
source $HOME/.bash_profile && celestia-appd keys show $WALLET -a
```


Show validators address
```
source $HOME/.bash_profile && celestia-appd keys show $WALLET --bech val -a
```
