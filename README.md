
# Infrastructure as Code Railway Deployment

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker Build](https://img.shields.io/badge/Docker-Ready-blue)](Dockerfile)
[![Tailscale VPN](https://img.shields.io/badge/Tailscale-Integrated-7B68EE)](https://tailscale.com)

A secure, containerized infrastructure solution combining cloud storage, VPN access, and web services with automated deployment.

## Features

- 🐳 **Docker Containerization**
- 🌐 **Flask Web Application**
- 🔒 **SSH Access via Ngrok Tunnel**
- ☁️ **Rclone Cloud Storage Integration**
- 🛡️ **Tailscale VPN with ACL Controls**
- 📡 **DNS-over-TLS (Stubby Configuration)**
- 🔄 **Automated CI/CD Ready**

## Prerequisites

- Docker 20.10+
- [Tailscale Account](https://tailscale.com)
- Ngrok Auth Token
- Python 3.12+
- Cloud Storage Account (Google Drive/Dropbox/etc)

## Installation

```bash
git clone https://github.com/yunus25jmi1/infrastructureascode-railway.git
cd yunus25jmi1-infrastructureascode-railway
cp .env.example .env
```

## Configuration

### Environment Variables (`.env`)
```ini
# Core Configuration
NGROK_TOKEN=your_ngrok_auth_token
PORT=22

# Tailscale VPN
TAILSCALE_AUTHKEY=tskey-auth-xxxxxxxx
TAILSCALE_HOSTNAME=railway-vpn
TAILSCALE_ADVERTISE_ROUTES=10.0.0.0/24

# Rclone Storage
CLOUD_NAME=your-cloud-config-name
SUB_DIR=/backups
BASE_CONF=base64_encoded_rclone_config
```

### Tailscale Setup
1. **Generate Auth Key**:
   - Go to [Tailscale Admin Console → Keys](https://login.tailscale.com/admin/settings/keys)
   - Create key with:
     - Ephemeral: Enabled
     - Tags: `tag:ssh-server`
     - Expiry: 90 days

2. **ACL Configuration** (`tailscale-policy.json`):
```json
{
  "acls": [
    {
      "action": "accept",
      "src": ["your-email@domain.com"],
      "dst": ["tag:ssh-server:*"]
    }
  ],
  "tagOwners": {
    "tag:ssh-server": ["your-email@domain.com"],
    "tag:vpn": ["your-email@domain.com"]
  },
  "ssh": [
    {
      "action": "check",
      "src": ["your-email@domain.com"],
      "dst": ["tag:ssh-server"],
      "users": ["root"]
    }
  ]
}
```

### Rclone Setup
1. Generate Configuration:
```bash
rclone config
```

2. Encode Configuration:
```bash
cat ~/.config/rclone/rclone.conf | base64 --wrap=0
```

3. Update `.env` with:
```ini
BASE_CONF=generated_base64_string
CLOUD_NAME=your_config_section_name
```

## Deployment

### Local Docker
```bash
docker build -t infra-railway .
docker run -d --env-file .env \
  --cap-add=NET_ADMIN \
  -p 22:22 \
  -p 5000:5000 \
  infra-railway
```

### Heroku
1. Set environment variables in Heroku Dashboard
2. Deploy:
```bash
heroku container:push web
heroku container:release web
```

### Render
1. Create new Web Service using `render.yaml`
2. Set environment variables:
   - `TAILSCALE_AUTHKEY`
   - `NGROK_TOKEN`
   - `BASE_CONF`

## Usage

### SSH Access
```bash
# Via Tailscale
ssh root@railway-vpn

# Via Ngrok (Fallback)
ssh root@[ngrok_host] -p [ngrok_port]
Password: Demo1234
```

### Web Interface
Access at `http://localhost:5000` or your deployment URL

### Cloud Storage
```bash
# SFTP Access
sftp -P 2022 root@railway-vpn

# Mount Storage
sshfs -p 2022 root@railway-vpn:/storage /mnt/cloud
```

### VPN Management
```bash
# Check VPN Status
tailscale status

# Advertise Routes
tailscale up --advertise-routes=10.0.0.0/24
```

## Security

1. **First Run Checklist**:
   ```bash
   # Change SSH Password
   echo "root:$(openssl rand -base64 12)" | chpasswd

   # Rotate Tailscale Key
   tailscale logout && tailscale up --authkey=new-key
   ```

2. **Firewall Rules**:
   ```bash
   ufw allow in on tailscale0
   ufw deny 22/tcp
   ```

3. **Monitoring**:
   ```bash
   # View VPN Logs
   journalctl -u tailscaled

   # Check SSH Attempts
   grep sshd /var/log/auth.log
   ```

## Troubleshooting

### Common Issues

**Tailscale Connection Failures**
```bash
tailscale netcheck
tailscale ping railway-vpn
```

**SSH Access Problems**
```bash
# Verify Service Status
docker exec [container] service ssh status

# Check Ngrok Tunnel
curl http://localhost:4040/api/tunnels
```

**Rclone Mount Errors**
```bash
# Validate Configuration
docker exec [container] rclone config show

# Test Connection
docker exec [container] rclone ls ${CLOUD_NAME}:
```

## Appendix

### Project Structure

```
yunus25jmi1-infrastructureascode-railway/
├── app/                         # Flask web application
│   ├── app.py                   # Main application logic
│   ├── requirements.txt         # Python dependencies
│   ├── start.sh                 # App startup script
│   └── wsgi.py                  # WSGI entry point
│
├── deploy-container/            # Deployment configurations
│   ├── entrypoint.sh            # Container init script
│   ├── rclone-tasks.json        # Rclone automation config
│   └── settings.json            # VSCode server settings
│
├── stubby/                      # DNS-over-TLS config
│   └── stubby.yml               # DNS privacy settings
│
├── Dockerfile                   # Multi-stage container build
├── LICENSE                      # MIT License
├── README.md                    # Project documentation
├── app.json                     # Heroku app manifest
├── heroku.yml                   # Heroku deployment config
├── install.sh                   # Rclone installer
├── openssh.sh                   # SSH+Ngrok manager
├── rclone.conf                  # Cloud storage config
├── rclone_conf.sh               # Config encoder
├── render.yaml                  # Render.com IaC config
├── run.sh                       # Rclone service control
├── sftp.json                    # SFTP client config
└── start.sh                     # Main entrypoint script
```

### Network Architecture Diagram

```mermaid
graph TD
    A[User] -->|Access Methods| B[Docker Container]
    B --> C[Flask Web App]
    B --> D[SSH Server]
    B --> E[Rclone SFTP]
    B --> F[Tailscale VPN]
    
    subgraph Docker Container
        C -->|Port 5000| G[Gunicorn Server]
        D -->|Port 22| H[OpenSSH]
        D --> I[Ngrok Tunnel]
        E -->|Port 2022| J[Cloud Storage]
        F -->|Userspace Networking| K[Tailscale Network]
    end
    
    I --> L[Ngrok Infrastructure]
    J --> M[Cloud Storage Providers]
    K --> N[Tailscale Control Plane]
    
    A -->|HTTPS| C
    A -->|SSH| D
    A -->|SFTP| E
    A -->|Tailscale VPN| F
    
    style B fill:#f,stroke:#333,stroke-width:3px
    style C fill:#f,stroke:#333
    style D fill:#f,stroke:#333
    style E fill:#f,stroke:#333
    style F fill:#f,stroke:#333

```

### Key Components

| Component           | Description                                  | Key Files                     |
|---------------------|----------------------------------------------|-------------------------------|
| **Web Application** | Flask-based web interface                    | `app/`, `Dockerfile`          |
| **VPN Access**      | Tailscale secure networking                  | `start-tailscale.sh`          |
| **SSH Tunnel**      | Ngrok-managed secure access                  | `openssh.sh`                  |
| **Cloud Storage**   | Rclone cloud integration                     | `rclone.conf`, `run.sh`       |
| **DNS Security**    | Stubby DNS-over-TLS configuration           | `stubby/stubby.yml`           |
| **Deployment**      | Multi-cloud deployment configs               | `render.yaml`, `heroku.yml`   |



**Maintenance Tips**:
- Rotate `TAILSCALE_AUTHKEY` every 90 days
- Monitor Tailscale Admin Console regularly
- Use `rclone config reconnect` for storage tokens
- Enable 2FA on all connected services


## License
MIT License - See [LICENSE](LICENSE) for full text.

---

