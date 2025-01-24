#!/bin/bash

# Start Tailscale in userspace mode
echo "Starting Tailscale in userspace networking mode..."
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

# Wait for Tailscale daemon to initialize
sleep 5

# Authenticate and connect to Tailscale network
echo "Connecting to Tailscale network with hostname '${TAILSCALE_HOSTNAME:-railway-vpn}'..."
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="${TAILSCALE_HOSTNAME:-railway-vpn}" \
  --advertise-routes="${TAILSCALE_ADVERTISE_ROUTES:-10.0.0.0/24,172.16.0.0/12}" \
  --advertise-exit-node ${TAILSCALE_EXTRA_ARGS}

# Display connection information
echo "Tailscale VPN Status:"
tailscale status

# Keep the script running
sleep infinity
