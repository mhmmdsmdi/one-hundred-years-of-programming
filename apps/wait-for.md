# wait-for script

[Official Repository](https://github.com/eficode/wait-for)

Download latest `wait-for.sh` file from official repository and put it near `docker-compose.yaml` file, then add this to compose file :

```yaml
volumes:
  - type: bind
    source: ./wait-for.sh
    target: /wait-for.sh
entrypoint:
  - /bin/sh
  - /wait-for.sh
  - <IP>:<PORT>
  - --
  - tini
  - --
  - /docker-entrypoint.sh
```

`Todo` make the script better.
