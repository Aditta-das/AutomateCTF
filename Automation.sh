#!/bin/bash

DIR="scans"
VMIP=$(ifconfig 'tun0' | grep '10.*' | awk '{print $2}')
if [ -z "$VMIP" ]; then 
    echo "Play KOTH. What Are you doing? :("
else
    echo $VMIP
fi

if [ -d "$DIR" ]; then
    echo "Directory '$DIR' exists."
else
    echo "Directory '$DIR' does not exist. Creating it..."
    mkdir -p "$DIR"
    cd "$DIR" && echo "Changed to directory: $(pwd)"
fi

recursiveInput() {
    while [[ $choice -gt 4 ]]; 
    do
        read -p "Choose 1-4 >> " choice
    done
}

nmapScan() {
    echo "Running nmap scan..."
    echo "#############################"
    echo "#           NMAP            #"
    echo "#############################"
    echo "NMAP SCAN" >> nmap.log
    echo "" >> nmap.log
    nmap -sC -sV -A $ScanIP >> nmap.log
    echo "Finish Scan"
}

rustSearch() {
    echo "Running rustscan..."
    echo "#############################" 
    echo "#        RUST SCAN          #"
    echo "#############################"
    echo "RUST SCAN" >> rust.log
    echo "" >> rust.log
    rustscan -a $ScanIP -- -sC -sV >> rust.log
    echo "Finish Scan"
}

gobDirSearch() {
    echo "Running Gobuster..."
    echo "#############################" 
    echo "#      GOBUSTER SEARCH      #"
    echo "#############################"
    read -p "Type wordlist path here >> /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt >> " path
    sleep 5
    if [ -z "$path" ]; then
        path="/home/aditta/Downloads/ELEMENTS/dirb/directory-list-2.3-medium.txt"
    fi
    gobuster dir -u $ScanIP -w $path
}

basicExpectation() {
    read -p "Enter VM IP > " ScanIP
    ping -c 2 $ScanIP > ping.log 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Network Unreachable"
        exit 1  # Exit if the network is unreachable
    else
        echo "$ScanIP running"
    fi

    echo "########################"
    echo "# 1. nmap              #"
    echo "# 2. rustscan          #"
    echo "# 3. gobuster          #"
    echo "# 4. dirsearch         #"
    echo "########################"

    IFS="," read -p "Choose option with comma separation (like 1,3 / 1,2,3): " -ra choices
    for choice in ${choices[@]}; do
        if [[ $choice -gt 4 ]]; then
            recursiveInput $choice
        fi
        case $choice in
            1)
                nmapScan &  # Run nmap in the background
                ;;  
            2)
                rustSearch &  # Run rustscan in the background
                ;;
            3)
                gobDirSearch &  # Run Gobuster in the background
                ;;
            4)
                echo "Running dirsearch..." &
                # Add the actual dirsearch command here if needed
                ;;
        esac
    done    
    wait
}

basicExpectation
