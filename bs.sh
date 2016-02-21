# !/bin/bash
# file: bs.sh, bs_instaler.sh, bs_lite.apk
# Author:	Michal Blažek
# Date:		10.12.2015

# Před použitím
# Povolit instalaci z cizích zdrojů

#Instalace bs_lite do systémových aplikací
adb push bs_lite.apk /mnt/sdcard/
echo bs_lite.apk --- Nahran do /mnt/sdcard/bs_lite.apk

#Instalace "velkého" Blindshellu (první parametr)
echo Instaluji $2 - může to chvilku trvat
adb install $2
echo INSTALACE DOKONČENA--- $2

#Nahrání nastavovacího scriptu 
adb push bs_instaler.sh /mnt/sdcard/
echo bs_instaler.sh --- Nahran do /mnt/sdcard/bs_instaler.sh

#Spuštění nastavovacího scriptu 
adb shell su sh /mnt/sdcard/bs_instaler.sh $1
echo bs_instaler.sh --- Hotovo

#adb shell su reboot
#adb shell su rm /mnt/sdcard/bs_instaler.sh

#echo bs_instaler.sh --- Uklizeno 