#!/bin/bash

# Install iptables-persistent if not installed
if ! dpkg -l | grep -q iptables-persistent; then
    apt-get update
    apt-get install -y iptables-persistent
fi

# Add iptables rule to forward all TCP and UDP traffic to any client
iptables -t nat -A PREROUTING -p tcp -j ACCEPT
iptables -t nat -A PREROUTING -p udp -j ACCEPT

# Save iptables rules
iptables-save > /etc/iptables/rules.v4
echo "All TCP and UDP traffic is now accepted for all clients."
