# Docker Log Investigation – Quick Notes

These commands are used to identify **which Docker service/container is generating excessive logs**.

```
sudo du -h /var/lib/docker/containers/*/*-json.log | sort -hr
```

Finds the largest Docker log files.

```
docker ps -a --no-trunc | grep <container_id>
```

Maps a log file’s container ID to the actual container/service.

```
sudo truncate -s 0 /var/lib/docker/containers/*/*-json.log
```

Clears Docker logs after identifying the noisy service.