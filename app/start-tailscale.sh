#!/bin/bash

# Start Tailscale daemon
echo "Starting Tailscale in userspace mode..."
tailscale --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state &

# Wait for daemon initialization
sleep 5

# Connect to Tailscale network
echo "Authenticating with hostname: ${TAILSCALE_HOSTNAME}"
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="${TAILSCALE_HOSTNAME}" \
  --advertise-exit-node

# Keep container running
tail -f /dev/null