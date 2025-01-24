# Base image for the Python app
FROM python:3.12-alpine AS app

# Set working directory
WORKDIR /app

# Copy and install requirements
COPY ./app/requirements.txt /app/app/
RUN pip install --no-cache-dir -r /app/app/requirements.txt

# Copy application code
COPY ./app /app/app

# Command to start the Python app
CMD ["/app/app/start.sh"]

# Base image for the SSH + Ngrok setup
FROM ubuntu:latest AS ssh-ngrok

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    ssh wget curl vim python3 sudo tmux net-tools iputils-ping gnupg lsb-release \
    && apt-get clean

# Install Tailscale using official install script
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && curl -fsSL https://tailscale.com/install.sh | sh -s -- \
        --skip-apt-update \
        --skip-start \
        --accept-license \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Ngrok using official repository
RUN mkdir -p /etc/apt/trusted.gpg.d && \
    curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
    tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
    tee /etc/apt/sources.list.d/ngrok.list && \
    apt-get update && \
    apt-get install -y ngrok && \
    apt-get clean

# Configure SSH
RUN mkdir /run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "root:Demo1234" | chpasswd

# Copy configuration files
COPY rclone.conf /.config/rclone/
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json
COPY openssh.sh /openssh.sh

# Add environment-based configuration
RUN mkdir -p /.config/rclone/
ENV RCLONE_CONFIG=/app/.rclone.conf

# Copy startup scripts
COPY openssh.sh /openssh.sh
COPY start-tailscale.sh /start-tailscale.sh

# Make scripts executable
RUN chmod +x /openssh.sh /start-tailscale.sh

# Make openssh.sh executable
RUN chmod +x /openssh.sh

# Expose necessary ports
EXPOSE 22 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000 7800 3000 9800

# Entrypoint script
CMD ["/bin/bash", "/openssh.sh"]
