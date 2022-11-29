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

wget -q -O Celestia_node.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Celestia_node.sh && chmod +x Celestia_node.sh && sudo /bin/bash Celestia_node.sh
```
![image](https://user-images.githubusercontent.com/83507970/204498896-b034857d-e020-4b0d-9fe7-e0175f059d38.png)

เลือกหมายเลข 1 สำหรับการติดตั้งแบบไม่โหลด snap short แล้้วค่อยมา โหลด snap short ทีหลัง แนะนำสำหรับคนที่คิดว่า internet ไม่ค่อยดี เพราะ แบบนี้จะไม่ต้องมาลงใหม่หาก net หลุด 
หากเลือกติดตั้งแบบ 1 เมื่อติดตั้งเสร็จให้จด seed ของตัวเองเอาไว้ด้วย หลังจากนั้นให้เลือก เมนู 4 เพื่อทำการ download sanp short 

เลือกหมายเลข 2 สำหรับการติดตั้งแบบโหลด snap short แนะนำให้เลือกข้อนี้สำหรับคนที่ internet ของ server แรง แต่อาจจะใช้เวลา sync นานหน่อย ตามความเร็ว internet ของ server 2 - 12 ชั่วโมง

เมื่อถึงขั้นตอนการตั้งชื่อ Node Name and Wallet Name  ควรตั้งชื่อเป็น ภาษาอังกฤษ เท่านั้น ห้ามมีตัวอักษรพิเศษ อย่าลืมจด seed เก็บไว้ ถ้าไม่ได้จด จะไม่สามารถ recovery หรือ ย้าย wallet ได้

เมื่อได้เลขกระเป็ามาแล้ว ให้เอาไปขอ Token ใน discord ของ celestia

หลังจากติดตั้งแล้ว สามารถ พิมพ์ 3 แล้ว enter เพือดู block sync ได้
หากต้องการออกจาก เมนูให้ พิมพ์ 10 แล้ว enter



## 3. ตรวจสอบ Block sync จากเมนูหมายเลข 3

![image](https://user-images.githubusercontent.com/83507970/204498908-08c71226-849e-45da-8c1f-00808d000f12.png)

สามารถกดดูได้เรื่อย ๆ โดยการพิมพ์ 3 แล้ว enter หากต้องการออกจาก เมนูให้ พิมพ์ 10 แล้ว enter




## 4. ตรวจสอบ Balance  จากเมนูหมายเลข 5

![image](https://user-images.githubusercontent.com/83507970/204498916-288312ed-99e0-4038-9577-3f0ad38d686b.png)

หากต้องการออกจาก เมนูให้ พิมพ์ 10 แล้ว enter


## 5. สร้าง validator node จากเมนูหมายเลข 6
ก่อนจะรันคำสั่งนี้ ต้องตรวจสอบ Block sync และ ได้ balance แล้ว 
![image](https://user-images.githubusercontent.com/83507970/204498930-4996a60c-1d1e-46ce-818f-666a7534300e.png)

หากต้องการออกจาก เมนูให้ พิมพ์ 10 แล้ว enter


## 6. สำหรับคนที่อยากลบลงใหม่ ให้เลือกเมนู ข้อ 9
หลังจากลบเรียบร้อยแล้ว ให้กดปิดหน้าจอ server ไป แล้วเปิดขึ้นมาใหม่ ถึงทำการ install ใหม่อีกครั้งนะ

![image](https://user-images.githubusercontent.com/83507970/204498941-76c4fe6c-f7f5-48e9-a996-e748c33f983f.png)






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
