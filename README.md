# caddy-dns-desec

Caddy Docker image with the `caddy-dns/desec` plugin pre-installed. 

Use this image to handle Let's Encrypt DNS-01 challenges for wildcard certificates (`*.dedyn.io`) under deSEC. The image is rebuilt every week via GH actions.

## Quick Start

### 1. Docker Compose

```yaml
services:
  caddy:
    image: ghcr.io/ax1111yt/caddy-desec:latest
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    environment:
      - DESEC_TOKEN=${DESEC_TOKEN}
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
  caddy_config:

```

### 2. Environment Setup

Store your deSEC API token in a `.env` file in the same directory:

```env
DESEC_TOKEN=your_token_here

```

### 3. Caddyfile Configuration

```caddy
*.yourdomain.dedyn.io {
    tls {
        dns desec {env.DESEC_TOKEN}
    }

    @app1 host app1.yourdomain.dedyn.io
    handle @app1 {
        reverse_proxy app-container:8080
    }

    handle {
        abort
    }
}

```

## Updates

To pull the latest weekly build and recreate the container:

```bash
docker compose pull && docker compose up -d

```
