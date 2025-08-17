# Watchtower - A container-based solution for automating Docker container base image updates

[Official website](https://containrrr.dev/watchtower/)

## Docker

```sh
docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
```

## Docker compose

```yaml
version: "3"
services:
  watchtower:
    image: containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
