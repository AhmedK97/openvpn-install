#!/bin/bash

# Install iptables-persistent if not installed
if ! dpkg -l | grep -q iptables-persistent; then
    apt-get update
    apt-get install -y iptables-persistent
fi

# Ask for the OpenVPN client IP
read -p "Enter the OpenVPN client IP: " CLIENT_IP

# Add iptables rule to forward all TCP traffic
iptables -t nat -A PREROUTING -p tcp -j DNAT --to-destination $CLIENT_IP
iptables -t nat -A PREROUTING -p udp -j DNAT --to-destination $CLIENT_IP

# Save iptables rules
iptables-save > /etc/iptables/rules.v4
echo "All TCP and UDP traffic is now forwarded to $CLIENT_IP."
