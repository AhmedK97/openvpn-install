#!/bin/bash

# Install iptables-persistent silently if not installed
if ! dpkg -l | grep -q iptables-persistent; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get install -y -qq iptables-persistent > /dev/null 2>&1
fi

# Ask for the OpenVPN client IP
read -p "Enter the OpenVPN client IP: " CLIENT_IP

# Forward all TCP ports
iptables -t nat -A PREROUTING -p tcp --dport 1:65535 -j DNAT --to-destination $CLIENT_IP
echo "All TCP ports forwarded to $CLIENT_IP"

# Forward all UDP ports
iptables -t nat -A PREROUTING -p udp --dport 1:65535 -j DNAT --to-destination $CLIENT_IP
echo "All UDP ports forwarded to $CLIENT_IP"

# Save iptables rules
iptables-save > /etc/iptables/rules.v4
echo "Iptables rules saved."
