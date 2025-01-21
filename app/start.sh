#!/bin/sh

# Ensure necessary environment variables are set
if [ -z "$TAILSCALE_AUTHKEY" ]; then
    echo "Error: Missing TAILSCALE_AUTHKEY environment variable."
    exit 1
fi

if [ -z "$PORT" ]; then
    echo "Error: Missing PORT environment variable. Defaulting to 5000."
    PORT=5000
fi

# Start Tailscale in userspace networking mode
echo "Starting Tailscale in userspace networking mode..."
/app/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

# Wait for Tailscale daemon to start
sleep 5

# Connect to Tailscale network with the provided auth key
echo "Connecting to Tailscale network with hostname 'ephemeral-vpn-${PORT}'..."
/app/tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname="ephemeral-vpn-${PORT}" --advertise-exit-node

if [ $? -ne 0 ]; then
    echo "Error: Failed to connect to Tailscale network. Check your TAILSCALE_AUTHKEY."
    exit 1
fi

echo "Tailscale started successfully."

# Set ALL_PROXY to use Tailscale's SOCKS5 server
export ALL_PROXY=socks5://localhost:1055/
echo "ALL_PROXY set to 'socks5://localhost:1055/'."

# Start Gunicorn server to run the Flask app
echo "Starting Gunicorn server on port ${PORT}..."
gunicorn --bind "0.0.0.0:${PORT}" --workers 2 --threads 2 app.wsgi:app
