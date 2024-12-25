#!/bin/bash

function King() {
    echo "[+] Starting execution"
    
    cat < koth.sh > koth1.sh
    # Check if the script is running as root
    if [ "$EUID" -ne 0 ]; then
        echo "[-] Please run as root."
        exit 1
    fi

    # Navigate to the /root directory
    cd /root || { echo "[-] Failed to change to /root"; exit 1; }
    echo "[+] Root Path: $(pwd)"

    # Check if an argument (your IP address) is provided
    if [ -z "$1" ]; then
        echo "[-] No IP address provided. Usage: ./king.sh <YOUR_IP_ADDRESS>"
        exit 1
    fi

    # Store your IP address
    YOUR_IP="$1"

    # Extract TTYs and IPs, display your TTY, and list others
    echo "[+] Checking for TTYs with IPs:"
    w -h | awk '{print $2, $3}' | while read -r TTY IP; do
        if [[ $IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            if [ "$IP" == "$YOUR_IP" ]; then
                echo "[!] Your TTY: $TTY | Your IP: $IP"
            else
                echo "Other TTY: $TTY | Other IP: $IP"
                echo "[-] Killing TTY"
                $(pkill -t -9 $TTY)
                echo "[-] Blocking IP"  
                $(iptables -A INPUT -s $IP -j DROP)
            fi
        fi
    done
}

# Call the function with the provided argument
King "$1"
