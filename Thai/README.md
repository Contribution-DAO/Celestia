# ขั้นตอนการติดตั้ง Node Celestia

## ความต้องการของเครื่องในการทำ Validator node
The following hardware minimum requirements are recommended for running the validator node:

>:black_square_button:  OS Ubuntu 18.04 - 22.04<br> 
>:black_square_button:Memory: 8 GB RAM<br> 
>:black_square_button:CPU: Quad-Core<br> 
>:black_square_button:Disk: 250 GB SSD Storage<br> 
>:black_square_button:Bandwidth: 1 Gbps for Download/100 Mbps for Upload<br> 
>:black_square_button:TCP Port: 26656,26657,26660,9090<br>


## 1. ขั้นตอนแรกให้ทำการเปลี่ยน user เป็น root ก่อนทุกครั้ง

```

sudo su
```


## 2. ทำการติดตั้ง Validator node จาก script 

```

wget -q -O Celestia_node.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Celestia_node.sh && chmod +x Celestia_node.shh && sudo /bin/bash Celestia_node.sh
```
![image](https://user-images.githubusercontent.com/83507970/204495928-97cee31e-1a8c-400f-ac13-4d79f09d111b.png)

เลือกหมายเลข 1 สำหรับการติดตั้งแบบไม่โหลด snap short

เลือกหมายเลข 2 สำหรับการติดตั้งแบบโหลด snap short แนะนำให้เลือกข้อนี้ แต่อาจจะใช้เวลา sync นานหน่อย ตามความเร็ว internet ของ server 2 - 12 ชั่วโมง

เมื่อถึงขั้นตอนการตั้งชื่อ Node Name and Wallet Name  ควรตั้งชื่อเป็น ภาษาอังกฤษ เท่านั้น ห้ามมีตัวอักษรพิเศษ อย่าลืมจด seed เก็บไว้ ถ้าไม่ได้จด จะไม่สามารถ recovery หรือ ย้าย wallet ได้

เมื่อได้เลขกระเป็ามาแล้ว ให้เอาไปขอ Token ใน discord ของ celestia



## 3. ตรวจสอบ Block sync จากเมนูหมายเลข 3

![image](https://user-images.githubusercontent.com/83507970/204495972-f1eaeb4e-1b49-4204-a1a6-fd35b2b1f7ec.png)




## 4. ตรวจสอบ Balance  จากเมนูหมายเลข 4



## 5. สร้าง validator node จากเมนูหมายเลข 5
ก่อนจะรันคำสั่งนี้ ต้องตรวจสอบ Block sync และ ได้ balance แล้ว 


## 6. สำหรับคนที่อยากลบลงใหม่ ให้เลือกเมนู ข้อ 8







## 8. คำสั่งพื้นฐานทั่วไป

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
