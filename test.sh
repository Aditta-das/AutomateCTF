#!/bin/bash

# Function for running nmap scan
nmapScan() {
    echo "Running nmap scan on $1..."
    echo "#############################"
    echo "#           NMAP            #"
    echo "#############################"
    nmap -sC -sV -A $1
}

# Function for counting from 1 to n
count() {
    local n=$1
    echo "Counting from 1 to $n..."
    for (( i=1; i<=n; i++ )); do
        echo $i
        sleep 1
    done
}

# Function to handle user input and execute tasks
runTasks() {
    read -p "Enter IP for nmap scan: " ip
    read -p "Enter count number: " countTo
    read -p "Choose task(s) to run simultaneously (1 for nmap, 2 for count, e.g., 1,2): " tasks

    # Run selected tasks in parallel
    IFS="," read -r -a selectedTasks <<< "$tasks"
    
    for task in "${selectedTasks[@]}"; do
        case $task in
            1)
                # Run nmap scan in the background
                nmapScan $ip &
                ;;
            2)
                # Run count in the background
                count $countTo &
                ;;
            *)
                echo "Invalid task: $task"
                ;;
        esac
    done

    # Wait for all background tasks to finish
    wait
}

# Main function to start the script
runTasks
