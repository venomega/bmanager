#!/bin/bash

# AUTHOR Guillermo Plasencia

## REQUERIMENTS
# IW
#wpa_supplicant
#iputils2
#coreutils (OF CURSE)
# RUN AS ROOT
# run in folder with write permisions

# TODO
#multi-interface handling
#connect to network without passwd
#delete network profiles
#static ip address & gateway
PWD=$(pwd)
cd script/wifi
get_interface_name() {
    WLAN=$(iw dev | grep Interface | cut -d " " -f 2)
}

check_interface() {
    ip link show ${WLAN} | grep DOWN &>/dev/null

    
    if [ $?  =  0 ]; then
	$(ip link set ${WLAN} up)
	
    fi
}
scan_network(){
    iw dev ${WLAN} scan > tmp.tmp
    if [ $? != 0 ]; then
	exit 1
    fi
    
    cat tmp.tmp | grep freq > freq.tmp
    cat tmp.tmp | grep SSID > ssid.tmp
    cat tmp.tmp | grep signal > db.tmp    
}

display_network(){
    lines=$(wc -l $1 | cut -d " " -f 1)
    FILE=$1
    if [ -f ./${FILE}.txt ]; then
	rm ./${FILE}.txt
    fi
    
    for line in $(seq 1 ${lines});
    do
	object=$(cat ${FILE} | sed -n ${line}p | cut -d ":" -f 2 )
	echo $object >> ./${FILE}.txt
    done
    
    #echo $ssid
}

display(){
    
    for i in $(seq 1 ${lines});
    do
	ssid=$(cat ssid.tmp.txt | sed -n ${i}p)
	freq=$(cat freq.tmp.txt | sed -n ${i}p)
	db=$(cat db.tmp.txt | sed -n ${i}p)
	printf "${i}: SSID:\"${ssid}\" ${freq}MHz  ${db}\n"
    done
    
}

reading() {
    echo "Elija el numero de la red a la que desea conectarse: "
    read INPUT
    # this doesnt work
    #if [ $INPUT > $lines ]; then
	#echo "Error, please try again"
	#reading
    #fi
    
}

creating_wpa() {
    CONF=$(cat ssid.tmp.txt | sed -n ${INPUT}p)
    if [ -d ./networks ]; then
	echo "Directory network exist... skipping"
    else
	mkdir ./networks
    fi
    cd networks
    
    if [ -f "${CONF}.conf" ]; then
	echo "file config exist... skipping"
    else
	
	echo "Enter ${CONF} passwd"
	wpa_passphrase  "${CONF}" > "${CONF}.conf"
	
    fi
    
}

connect(){
    
    if [ -f ./networks/*.conf ]; then
	ls  ./networks/  | cut -d "." -f 1 > list.tmp
	hola=$(wc -l ./list.tmp | cut -d " " -f 1)
	echo "Available Networks"
	for i in $(seq 1 $hola);
	do
	    echo "${i}: $(cat list.tmp | sed -n ${i}p)"

	done
	echo "Select the number of network to connect: "
	read number
	file=$(cat list.tmp | sed -n ${number}p)
	#cd ./script/wifi
	
	#wpa_supplicant -Dnl80211 -iwlan0 -c "./networks"
	
	wpa_supplicant -Dnl80211 -i${WLAN} -c "./networks/${file}.conf"&
    else
	echo "You dont have any configuration file yet"
    fi

    ## DHCP
    sleep 5
    dhclient $WLAN
}

preparing(){
    get_interface_name
    check_interface
    
}

configuring(){
    scan_network
    display_network ssid.tmp
    display_network freq.tmp
    display_network db.tmp
    display
    reading
    creating_wpa
    
}

down() {
    ip link set ${WLAN} down
}

main() {
    whoami=$(whoami)
    if [ $whoami != "root" ];then
	echo "Error, please run this script as root"
	exit -1
    fi

    ps -A | grep wpa_supplicant &> /dev/null
    
    if [ $? == 0 ]; then
	killall wpa_supplicant
    fi
    preparing
    printf "What do you want to do:\n1-Configure a new wifi network\n2-Connect to a existing wifi network\n@-Any other option set interface down\n"
    read command
    if [ $command = 1 ]; then
	configuring

    else
	if [ $command = 2 ]; then
	    connect
	else
	    down
	fi
	
    fi
}

main
