#!/bin/bash

# Install iptables-persistent if not installed
if ! dpkg -l | grep -q iptables-persistent; then
    apt-get update
    apt-get install -y iptables-persistent
fi

# Ask for the OpenVPN client IP
read -p "Enter the OpenVPN client IP: " CLIENT_IP

# Ask for the ports to forward (comma separated)
read -p "Enter the ports you want to forward (comma separated): " PORTS_INPUT

# Convert the comma-separated input into an array
IFS=',' read -r -a PORTS <<< "$PORTS_INPUT"

# Loop through each port and add iptables rule
for PORT in "${PORTS[@]}"; do
    iptables -t nat -A PREROUTING -p tcp --dport $PORT -j DNAT --to-destination $CLIENT_IP:$PORT
    echo "Port $PORT forwarded to $CLIENT_IP"
done

# Save iptables rules
iptables-save > /etc/iptables/rules.v4
echo "Iptables rules saved."
