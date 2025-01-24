#!/bin/bash

# Start Tailscale VPN
/start-tailscale.sh &

# Wait for Tailscale to initialize
sleep 10

# Start SSH server
echo "Starting OpenSSH server..."
/usr/sbin/sshd -D
