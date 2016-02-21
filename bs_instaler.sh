# !/bin/bash
# file: bs.sh, bs_instaler.sh, bs_lite.apk
# Author:	Michal Blažek
# Date:		10.12.2015

echo START bs_instaler 
wifi=0				#1 - set WiFI enable , 0 - set WiFI diable
mobileData=0
bluetooth=0
nfc=0
gps=0
noneLockScreen=0

brightness=130		#Jas - 1300 je 50%

instal_remove_BS_lite=$1

instalBs_lite=0		#1=nainstalovat bs_lite.apk, 0 = neinstalovat
removeBs_lite=1 	#1=odinstalovat bs_lite.apk, 0 = neodinstalovat

#Instalace bs_lite.apk
if [ $instal_remove_BS_lite = 1 ]
then
mount -o remount,rw /system
cp /storage/sdcard0/bs_lite.apk /system/priv-app/
cd /system/priv-app/
chmod 644 bs_lite.apk
mount -o remount, ro /system
echo ----------------
echo bs_lite.apk - Nainstalovano
ls -l bs_lite.apk
echo ----------------
cd /
fi

#Odinstalace bs_lite.apk
if [ $instal_remove_BS_lite = 0 ]
then
mount -o remount,rw /system
rm /system/priv-app/bs_lite.apk
mount -o remount, ro /system
echo ----------------
echo bs_lite.apk - Odinstalováno
echo ----------------
fi

#WIFI
if [ $wifi = 0 ]
	then
	svc wifi disable
	echo ----------------
	echo WiFi --- Disable
	echo ----------------
else
	svc wifi enable
	echo ----------------
	echo WiFi --- Enable
	echo ----------------
fi

#Mobile Data
if [ $mobileData = 0 ]
	then
	svc data disable
	echo ----------------
	echo Mobile Data --- Disable
	echo ----------------
else
	svc data enable
	echo ----------------
	echo Mobile Data --- Enable
	echo ----------------
fi

#Bluetooth
if [ $bluetooth = 0 ]
	then
	su -c service call bluetooth_manager 8
	echo ----------------
	echo Bluetooth --- Disable
	echo ----------------
else
	su -c service call bluetooth_manager 6
	echo ----------------
	echo Bluetooth --- Enable
	echo ----------------
fi

#NFC
if [ $nfc = 0 ]
	then
	service call nfc 7
	echo ----------------
	echo NFC --- Disable
	echo ----------------
else
	service call nfc 8
	echo ----------------
	echo NFC --- Enable
	echo ----------------
fi

#GPS
if [ $gps = 0 ]
	then
	settings put secure location_providers_allowed ' '
	echo ----------------
	echo GPS --- Disable
	echo ----------------
else
	settings put secure location_providers_allowed gps,network
	echo ----------------
	echo GPS --- Enable
	echo ----------------
fi

#Vypnout zvuky tlacitek

#Clear desktop

#Nastavit ukončení hovoru power buttonem

#Vypnout aktualizace
pm disable com.google.android.systemupdater

#Nastavit limit dipleje na 5min
sqlite3 /data/data/com.android.providers.settings/databases/settings.db "update system set value='300000' where name='screen_off_timeout';"

#Nastavit jas na 50%
settings put system screen_brightness $brightness
echo ----------------
echo Brightness is $brightness
echo ----------------

#Zruseni zamku displeje - set na NONE
if [ $noneLockScreen = 0 ]
	then
	sqlite3 /data/system/locksettings.db "UPDATE locksettings SET value = '1' WHERE name = 'lockscreen.disabled';"
	echo ----------------
	echo Screen  --- NONE
	echo ----------------
fi

#OTHER
#Zamknout diplej
#input keyevent 6

#Odemknout displej
#input keyevent 26

exit
exit
