# Heimdall - An elegant solution to organise all your web applications

## Installation

```yaml

services:
  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - ./heimdall/config:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped

```
