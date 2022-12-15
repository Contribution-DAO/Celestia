# ขั้นตอนการติดตั้ง Node Celestia

## ความต้องการของเครื่องในการทำ Validator node
The following hardware minimum requirements are recommended for running the validator node:

>:black_square_button:  OS Ubuntu 18.04 - 22.04<br> 

>:black_square_button:Memory: 8 GB RAM<br> 
สร้างจริง 4GB ก็พอ

>:black_square_button:CPU: Quad-Core<br> 

>:black_square_button:Disk: 250 GB SSD Storage<br> 
เขาแนะนำ 250GB แต่่สร้างแค่ 100GB ก็พอ

>:black_square_button:Bandwidth: 1 Gbps for Download/100 Mbps for Upload<br> 
>:black_square_button:TCP Port: 26656,26657,26660,9090<br>


## 1. ขั้นตอนแรกให้ทำการเปลี่ยน user เป็น root ก่อนทุกครั้ง

```

sudo su
```


## 2. ทำการติดตั้ง Validator node จาก script 

```

wget -q -O Mocha.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Mocha.sh && chmod +x Mocha.sh && sudo /bin/bash Mocha.sh
```
![image](https://user-images.githubusercontent.com/83507970/207964123-382545a1-1ad1-451e-8bc7-0069cab03330.png)

สำหรับคนที่ไม่เคยลงมาก่อน แนะนำให้ลงแบบ กดเลือกหมายเลข 2 ไปเลย


สำหรับคนที่เคยลงมาแล้ว เอากระเป๋าไปตรวจสอบบน https://celestia.explorers.guru/ พบว่ายังมี Token อยู่ และ ได้จด seed ของกระเป็าใบนั่นเอาไว้
ให้เลือกติดตั้งจากหมายเลข 3 


เมื่อ Script ถามหา EVM Adress ให้กรอก Address Metamask ลงไป แนะนำให้สร้างขึ้นมาใหม่ แล้วเอามากรอก
เมื่อถึงขั้นตอนการตั้งชื่อ Node Name and Wallet Name  ควรตั้งชื่อเป็น ภาษาอังกฤษ เท่านั้น ห้ามมีตัวอักษรพิเศษ 

หากเลือกติดตั้งแบบหมายเลข 3 เมื่อ script ทำงานไปสักพัก จะถามหา seed ของกระเป๋าใบเก่า ให้นำมากรอก แล้ว กด enter
![image](https://user-images.githubusercontent.com/83507970/207965395-5d1f2601-65b1-46d1-9f3a-a3c547044a1c.png)


เมื่อ script ติดตั้งเสร็จจะแสดงข้อมูล seed อย่าลืมจดเก็บไว้นะ
เมนู 2 จะสร้างเป่าขึ้นมา 2 ใบ ต้องจดทั้ง 2 ใบ
เมนู 3 จะสร้างเป่าขึ้นมา 1 ใบ 

ติดตั้งเสร็จ check balance มีก็กด 7 เพื่อสร้าง validator ต่อได้เลย

หลังจากติดตั้งแล้ว สามารถ พิมพ์ 3 แล้ว enter เพือดู block sync ได้
หากต้องการออกจาก เมนูให้ พิมพ์ 10 แล้ว enter



## 3. ตรวจสอบ Block sync จากเมนูหมายเลข 4

![image](https://user-images.githubusercontent.com/83507970/207965965-076c6195-1b30-440e-8fb0-559cd7f6d587.png)

สามารถกดดูได้เรื่อย ๆ โดยการพิมพ์ 4 แล้ว enter หากต้องการออกจาก เมนูให้ พิมพ์ 12 แล้ว enter




## 4. ตรวจสอบ Balance  จากเมนูหมายเลข 6

![image](https://user-images.githubusercontent.com/83507970/207965810-2aa666c3-1f83-4563-9a18-cf0346087e5b.png)

หากต้องการออกจาก เมนูให้ พิมพ์ 12 แล้ว enter


## 5. สร้าง validator node จากเมนูหมายเลข 7
ก่อนจะรันคำสั่งนี้ ต้องตรวจสอบ Block sync และ ได้ balance แล้ว 


หากต้องการออกจาก เมนูให้ พิมพ์ 12 แล้ว enter


## 6. สำหรับคนที่อยากลบลงใหม่ ให้เลือกเมนู ข้อ 10
หลังจากลบเรียบร้อยแล้ว ให้กดปิดหน้าจอ server ไป แล้วเปิดขึ้นมาใหม่ ถึงทำการ install ใหม่อีกครั้งนะ







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
source $HOME/.bash_profile && celestia-appd keys show $CWALLET -a
```


Show validators address
```
source $HOME/.bash_profile && celestia-appd keys show $CWALLET --bech val -a
```




