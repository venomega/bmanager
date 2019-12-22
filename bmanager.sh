#!/usr/bin/bash

# bmanager; script for network managment





check_modules() {
    MODULES=""
    token=$(ls | grep bmanager | grep -v bmanager.sh)
    for i in $token;
    do
	if [ -d ./"$i" ]; then
	    MODULES=("$MODULES $i  ")
	fi
    done
    echo $MODULES
}

show_modules(){
    check_modules
    echo "We found: $MODULES "
}

menu(){
    clear
    show_modules
    count=0
    echo "Welcome to bmanager"
    printf "Please select an option:\n"
    #LAN
    echo $MODULES | grep lan &>/dev/null
    if [ $? == 0 ]; then
	echo
}

main() {

    menu

}

main
