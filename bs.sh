# !/bin/bash
# file: bs.sh, bs_instaler.sh, bs_lite.apk
# Author:	Michal Blažek
# Date:		21.2.2015

# Před použitím
# Povolit instalaci z cizích zdrojů

#Parametry:
		# $1 parametr - 1 = nainstalovat systémovou aplikaci
		# $1 parametr - 0 = odinstalovat systémovou aplikaci

		# $2 parametr - cesta k apk aplikace


if [ -n "$1" ]
	then
	if [ $1 = -h ]
		then
		echo "\n[First parametr]: \ndetermines instalation (set 1) or unstalation (set 0) priv-system app bs_lite.apk."
		echo "\n[Second parametr]: \ndetermines path to full Blindshell.apk. This .apk have to signed by same signiture as bs_lite.apk.\n"

	else
		#Instalace bs_lite do systémových aplikací
		adb push bs_lite.apk /mnt/sdcard/ 
		echo bs_lite.apk --- Nahran do /mnt/sdcard/bs_lite.apk 

		#Instalace "velkého" Blindshellu (první parametr)
		if [ -n "$2" ]
			then
				echo Instaluji $2 - může to chvilku trvat
				adb install $2 
				echo INSTALACE DOKONČENA--- $2
		fi

		if [ $1 = 0 ]
			then
				echo Odintaluji 
				adb shell am start -a android.intent.action.DELETE -d "package:com.matapo.blindshell"
				adb uninstall com.matapo.blindshell
				echo ODINSTALOVÁNO
		fi

		#Nahrání nastavovacího scriptu 
		adb push bs_instaler.sh /mnt/sdcard/ 
		echo bs_instaler.sh --- Nahran do /mnt/sdcard/bs_instaler.sh "\n\t"

		#Spuštění nastavovacího scriptu 
		adb shell su sh /mnt/sdcard/bs_instaler.sh $1 
		echo bs_instaler.sh --- Hotovo

		#adb shell su reboot
		adb shell su rm -f -i -r -d /mnt/sdcard/bs_instaler.sh > text.txt
		adb shell su rm -f -i -r -d /mnt/sdcard/bs_lite.apk > text.txt

		echo bs_instaler.sh --- Uklizeno
		echo bs_lite.apk --- Uklizeno 
	fi
else
	echo "\n[First parametr]: \ndetermines instalation (set 1) or unstalation (set 0) priv-system app bs_lite.apk."
	echo "\n[Second parametr]: \ndetermines path to full Blindshell.apk. This .apk have to signed by same signiture as bs_lite.apk.\n"
fi