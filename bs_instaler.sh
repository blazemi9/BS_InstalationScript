# !/bin/bash
# file: bs.sh, bs_instaler.sh, bs_lite.apk
# Author:	Michal Blažek
# Date:		21.2.2016

echo START bs_instaler 
wifi=0				#1 - set WiFI enable , 0 - set WiFI diable
mobileData=0
bluetooth=0
nfc=0
gps=0
noneLockScreen=0

brightness=130		#Jas - 1300 je 50%

instal_remove_BS_lite=$1

showSystemResponse=1

#Instalace bs_lite.apk
if [ $1 == 1 ]
then
	mount -o remount,rw /system
	cp /storage/sdcard0/bs_lite.apk /system/priv-app/
	cd /system/priv-app/
	chmod 644 bs_lite.apk
	mount -o remount, ro /system
	echo "\t"----------------
	echo "\t"bs_lite.apk - Nainstalovano
	ls -l bs_lite.apk
	echo "\t"----------------"\n"
	cd /
fi

#Odinstalace bs_lite.apk
if [ $instal_remove_BS_lite = 0 ]
then
	mount -o remount,rw /system
	rm /system/priv-app/bs_lite.apk
	mount -o remount, ro /system
	echo "\t"----------------
	echo "\t"bs_lite.apk - Odinstalováno
	echo "\t"----------------"\n"
fi

#WIFI
if [ $wifi = 0 ]
	then
	echo "\t"----------------
	echo "\t"WiFi --- Disable
	if [ $showSystemResponse = 0 ]
		then
		svc wifi disable > /dev/null
	else
		svc wifi disable
	fi
	echo "\t"----------------"\n"
else
	echo "\t"----------------
	echo "\t"WiFi --- Enable
	if [ $showSystemResponse = 0 ]
		then
		svc wifi enable > /dev/null
	else
		svc wifi enable
	fi
	echo "\t"----------------"\n"
fi

#Mobile Data
if [ $mobileData = 0 ]
	then	
	echo "\t"----------------
	echo "\t"Mobile Data --- Disable
	if [ $showSystemResponse = 0 ]
		then
		svc data disable > /dev/null
	else
		svc data disable
	fi
	echo "\t"----------------"\n"
else
	echo "\t"----------------
	echo "\t"Mobile Data --- Enable
	if [ $showSystemResponse = 0 ]
		then
		svc data enable > /dev/null
	else
		svc data enable
	fi
	echo "\t"----------------"\n"
fi

#Bluetooth
if [ $bluetooth = 0 ]
	then	
	echo "\t"----------------
	echo "\t"Bluetooth --- Disable
	if [ $showSystemResponse = 0 ]
		then
		su -c service call bluetooth_manager 8 > /dev/null
	else
		su -c service call bluetooth_manager 8 
	fi
	echo "\t"----------------"\n"
else
	echo "\t"----------------
	echo "\t"Bluetooth --- Enable
	if [ $showSystemResponse = 0 ]
		then
		su -c service call bluetooth_manager 6 > /dev/null
	else
		su -c service call bluetooth_manager 6 
	fi
	echo "\t"----------------"\n"
fi

#NFC
if [ $nfc = 0 ]
	then
	#service call nfc 7 
	echo "\t"----------------
	echo "\t"NFC --- Disable
	if [ $showSystemResponse = 0 ]
		then
		su -c service call nfc 7 > /dev/null
	else
		su -c service call nfc 7 
	fi
	echo "\t"----------------"\n"
else
	#service call nfc 8 
	echo "\t"----------------
	echo "\t"NFC --- Enable
	if [ $showSystemResponse = 0 ]
		then
		su -c service call nfc 8  > /dev/null
	else
		su -c service call nfc 8  
	fi
	echo "\t"----------------"\n"
fi

#GPS
if [ $gps = 0 ]
	then
	echo "\t"----------------
	echo "\t"GPS --- Disable
	settings put secure location_providers_allowed ' ' 
	echo "\t"----------------"\n"
else
	echo "\t"----------------
	echo "\t"GPS --- Enable
	settings put secure location_providers_allowed gps,network 
	echo "\t"----------------"\n"
fi

#Vypnout zvuky tlacitek

#Clear desktop

#Nastavit ukončení hovoru power buttonem

#Vypnout aktualizace
pm disable com.google.android.systemupdater

#Nastavit limit dipleje na 5min
if [ $showSystemResponse = 0 ]
		then
		sqlite3 /data/data/com.android.providers.settings/databases/settings.db "update system set value='300000' where name='screen_off_timeout';"  > /dev/null
	else
		sqlite3 /data/data/com.android.providers.settings/databases/settings.db "update system set value='300000' where name='screen_off_timeout';"  
fi

#Nastavit jas na 50%
echo "\t"----------------
echo "\t"Brightness is $brightness
if [ $showSystemResponse = 0 ]
		then
		settings put system screen_brightness $brightness  > /dev/null
	else
		settings put system screen_brightness $brightness  
	fi
echo "\t"----------------"\n"

#Zruseni zamku displeje - set na NONE
if [ $noneLockScreen = 0 ]
	then
	if [ $showSystemResponse = 0 ]
		then
		sqlite3 /data/system/locksettings.db "UPDATE locksettings SET value = '1' WHERE name = 'lockscreen.disabled';"   > /dev/null
	else
		sqlite3 /data/system/locksettings.db "UPDATE locksettings SET value = '1' WHERE name = 'lockscreen.disabled';"   
	fi
	echo "\t"----------------
	echo "\t"Screen  --- NONE
	echo "\t"----------------"\n"
fi

#OTHER
#Zamknout diplej
#input keyevent 6

#Odemknout displej
#input keyevent 26

exit
exit