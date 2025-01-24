Here's the updated README.md with Tailscale VPN integration details:

# Infrastructure as Code Railway Deployment

![Project Architecture](/assets/mermaid-diagram-2025-01-24-220128.png)

A secure infrastructure deployment solution featuring automated VPN access, SSH tunneling, and cloud storage integration.

## Features

- 🐳 Docker-based infrastructure with multi-stage builds
- 🌐 Flask web application with Gunicorn server
- 🔒 Secure SSH access via Ngrok tunneling
- ☁️ Rclone integration for cloud storage management
- 🛡️ **Automatic Tailscale VPN** with subnet routing
- 📡 DNS-over-TLS with Stubby configuration
- 🔑 MagicDNS for human-readable hostnames
- 📦 Deployment-ready for Heroku/Render

## Prerequisites

- Docker 20.10+
- [Tailscale Account](https://tailscale.com)
- Ngrok Auth Token
- Python 3.12+
- Cloud Storage Provider (Google Drive, etc.)

## Installation

```bash
git clone https://github.com/yunus25jmi1/infrastructureascode-railway.git
cd yunus25jmi1-infrastructureascode-railway
cp .env.example .env
```

## Configuration

### Environment Variables (.env)
```ini
# Core
NGROK_TOKEN=your_ngrok_token
PORT=22

# Tailscale VPN
TAILSCALE_AUTHKEY=tskey-auth-xxxxxxxxx  # REQUIRED
TAILSCALE_HOSTNAME=railway-vpn
TAILSCALE_ADVERTISE_ROUTES=10.0.0.0/24,192.168.1.0/24
TAILSCALE_TAGS=tag:ssh-server,tag:production

# Rclone
CLOUD_NAME=your-cloud-storage
SUB_DIR=/backups
BASE_CONF=base64_encoded_rclone_config
```

### Tailscale Setup
1. **Create Auth Key**:
   - Go to [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys)
   - Generate reusable key with:
     - Ephemeral: Enabled
     - Tags: `tag:ssh-server`
     - Expiry: 90 days

2. **Configure ACLs** (optional):
```json
{
  "acls": [
    {
      "action": "accept",
      "src": ["autogroup:members"],
      "dst": ["tag:ssh-server:*"]
    }
  ]
}
```

## Deployment

### Local Docker Setup
```bash
docker build -t infra-railway .
docker run -d --env-file .env \
  --cap-add=NET_ADMIN \
  -p 22:22 \
  -p 5000:5000 \
  infra-railway
```

### Cloud Deployment (Heroku/Render)
1. Add environment variables to your cloud provider
2. Enable these permissions:
   - **NET_ADMIN** capability
   - **Persistent storage** (for Rclone)
3. Deploy using included `heroku.yml` or `render.yaml`

## VPN & Network Access

### Connect via Tailscale
```bash
# Install Tailscale client
curl -fsSL https://tailscale.com/install.sh | sh

# Connect to your network
tailscale up --ssh
```

### Access Methods
| Service       | Protocol | Address                    |
|---------------|----------|----------------------------|
| SSH           | TCP      | `railway-vpn:22`           |
| Web Interface | HTTP     | `railway-vpn:5000`         |
| SFTP          | SSH      | `sftp://railway-vpn:22`    |
| VPN Subnets   | -        | `10.0.0.0/24, 192.168.1.0/24` |

## Usage Examples

### SSH Access via VPN
```bash
ssh root@railway-vpn
# Password: Demo1234
```

### Mount Cloud Storage
```bash
# Local mount point
mkdir -p /mnt/cloud-storage

# Mount via SSHFS
sshfs -o allow_other root@railway-vpn:/app/storage /mnt/cloud-storage
```

### Verify VPN Status
```bash
# Check advertised routes
tailscale status

# Test connectivity
tailscale ping railway-vpn
```

## Security Configuration

1. **Rotate Credentials**:
   ```bash
   # Change SSH password
   echo "root:$(openssl rand -base64 12)" | chpasswd

   # Rotate Tailscale key
   tailscale logout && tailscale up --authkey=new-key
   ```

2. **Network Hardening**:
   ```bash
   # Restrict SSH to VPN only
   ufw allow in on tailscale0 to any port 22
   ufw deny 22
   ```

## Troubleshooting

**Tailscale Issues**:
```bash
# View logs
journalctl -u tailscaled

# Debug connection
tailscale netcheck
```

**SSH Connection Problems**:
```bash
# Verify VPN status
tailscale status

# Check firewall rules
ufw status verbose
```

**Storage Mount Errors**:
```bash
# Debug Rclone
rclone config show
rclone ls ${CLOUD_NAME}:
```

## Network Architecture

```mermaid
graph TD
    A[User] -->|Tailscale VPN| B[(Railway Server)]
    B --> C[Ngrok Tunnel]
    B --> D[Cloud Storage]
    B --> E[Flask App]
    C -->|Fallback Access| A
    D -->|Rclone Sync| B
```

## License

MIT License - See [LICENSE](LICENSE) for details.

---

**Maintenance Tips**:
- Regularly rotate `TAILSCALE_AUTHKEY` every 90 days
- Monitor VPN connections in Tailscale admin console
- Use ephemeral nodes for temporary access
- Enable 2FA on Tailscale account