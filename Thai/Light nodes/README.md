# ขั้นตอนการติดตั้ง Celestia Light node

## ความต้องการของเครื่องในการทำ Light node
The following hardware minimum requirements are recommended for running the Light node:

>:black_square_button:  OS Ubuntu 20.04 (LTS) x64<br> 

Memory: 2 GB RAM

CPU: Single Core

Disk: 5 GB SSD Storage

Bandwidth: 56 Kbps for Download/56 Kbps for Upload

## 1. ขั้นตอนแรกให้ทำการเปลี่ยน user เป็น root ก่อนทุกครั้ง

```
sudo su
```

## 2. ติดตั้งจาก script

```
wget -q -O lightnodes.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Thai/Light%20nodes/lightnodes.sh && chmod +x lightnodes.sh && sudo /bin/bash lightnodes.sh
```
### เมื่อ script ทำงานไปถึงขั้นตอนสุดท้าย จะให้ตั้งชื่อ KEY หลังจากใส่ชื่อ KEY ลงไปแล้ว จะได้ Address และ mnemonic phrase ออกมา ให้ทำการจดบันทึกเก็บไว้ให้ดีนะ

## 3. ตรวจสอบการทำงาน ของ node 

```
sudo systemctl status celestia-lightd
```


## 4. ตรวจสอบ logs ของ node 

```
sudo journalctl -u celestia-lightd.service -f --no-hostname
```

## กรณีที่ต้องทาง celestia แจ้งให้ start node ด้วย key ของตัวเอง
4.1 stop node 
```
sudo systemctl stop celestia-lightd
```

4.2 ทำการ set up config & Start node ใหม่อีกครั้ง โดยเปลี่ยน YOU_KEY_NAME เป็นชื่อ KEY ที่ได้มาตอนติดตั้งจาก script ด้านบน

```
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
[Unit]
Description=celestia-lightd Light Node
After=network-online.target
 
[Service]
User=$USER
ExecStart=/usr/local/bin/celestia light start --core.ip https://grpc-mocha.pops.one/ --core.grpc.port 9090 --keyring.accname YOU_KEY_NAME --gateway --gateway.addr localhost --gateway.port 26659 --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
 
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl enable celestia-lightd
sudo systemctl start celestia-lightd
```
