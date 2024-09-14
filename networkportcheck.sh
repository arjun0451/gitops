#!/bin/bash

# Set the path to the input file from the ConfigMap
CONFIG_FILE="/config/connectivity-check.txt"

# Function to check TCP connectivity
check_tcp_connectivity() {
    local ip=$1
    local port=$2

    # Use nc (netcat) to check TCP connectivity
    if nc -z -w 5 $ip $port; then
        echo "TCP $ip:$port Connected"
    else
        echo "TCP $ip:$port Failed"
    fi
}

# Function to check UDP connectivity
check_udp_connectivity() {
    local ip=$1
    local port=$2

    # Use nc (netcat) to check UDP connectivity
    if nc -z -u -w 5 $ip $port; then
        echo "UDP $ip:$port Connected"
    else
        echo "UDP $ip:$port Failed"
    fi
}

# Check if the input file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

# Read the input file line by line
while IFS='|' read -r ip ports protocol; do
    # Skip empty lines or lines not matching the expected format
    if [[ -z "$ip" || -z "$ports" || -z "$protocol" ]]; then
        continue
    fi

    # Split ports by comma
    IFS=',' read -ra port_array <<< "$ports"

    # Check each port based on the protocol
    for port in "${port_array[@]}"; do
        if [[ "$protocol" == "T" ]]; then
            check_tcp_connectivity $ip $port
        elif [[ "$protocol" == "U" ]]; then
            check_udp_connectivity $ip $port
        else
            echo "Unknown protocol for $ip:$ports|$protocol"
        fi
    done
done < "$CONFIG_FILE"