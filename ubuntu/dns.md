# Configure DNS on Ubuntu Using systemd-resolved

This guide explains how to configure DNS on **Ubuntu** using the **systemd-resolved** service.

------

## 1. Edit the systemd-resolved configuration file

Open the configuration file:

```
sudo nano /etc/systemd/resolved.conf
```

------

## 2. Add DNS and FallbackDNS entries

In the **[Resolve]** section, add or modify the following lines:

`Shecan.ir`

```
[Resolve]
DNS=178.22.122.100 185.51.200.2
FallbackDNS=8.8.8.8
```



`begzar.IR`

```
[Resolve]
DNS=185.55.226.26 185.55.225.25
FallbackDNS=8.8.8.8
```

------

## 3. Restart the systemd-resolved service

```
sudo systemctl restart systemd-resolved
```

------

## 4. Link the resolv.conf file

```
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

------

## 