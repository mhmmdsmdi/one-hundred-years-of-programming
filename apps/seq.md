# Seq - The self-hosted search, analysis, and alerting server

[Official website](https://datalust.co/seq)

## Docker compose

```yaml

version: "2.0"

services:
  seq:
    image: datalust/seq:latest
    volumes:
      - /datadrive:/data
    environment:
      - ACCEPT_EULA=Y
      - BASE_URI=https://seq.dptsprotrans.com

```
