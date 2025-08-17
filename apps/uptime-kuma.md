# Uptime Kuma - Uptime Kuma is an easy-to-use self-hosted monitoring tool

[Official Website](https://uptime.kuma.pet/)
[Official Repository](https://github.com/louislam/uptime-kuma)

## Installation

```yaml
version: '3.3'

volumes:
  uptimekuma-data:
    driver: local

services:
  uptimekuma:
    image: louislam/uptime-kuma:latest
    container_name: uptimekuma
    ports:
      - 3001:3001
    volumes:
      - uptimekuma-data:/app/data
    restart: unless-stopped
```
