# **Proxy Setup Guide for Ubuntu Server**

This guide covers how to configure **system-wide proxy**, **APT proxy**, and **shell environment proxy** on Ubuntu Server.

------

## 1. Set System-Wide Proxy (Environment Variables)

Edit the global environment file:

```
sudo nano /etc/environment
```

Add your proxy settings:

```
http_proxy="http://USERNAME:PASSWORD@proxy.example.com:8080/"
https_proxy="http://USERNAME:PASSWORD@proxy.example.com:8080/"
ftp_proxy="http://USERNAME:PASSWORD@proxy.example.com:8080/"
no_proxy="localhost,127.0.0.1,::1"
```

> If your proxy has no username/password, remove `USERNAME:PASSWORD@`.

Apply the changes:

```
source /etc/environment
```

------

## 2. Set Proxy for APT (Package Manager)

Create the APT proxy configuration file:

```
sudo nano /etc/apt/apt.conf.d/95proxies
```

Add:

```
Acquire::http::Proxy "http://USERNAME:PASSWORD@proxy.example.com:8080/";
Acquire::https::Proxy "http://USERNAME:PASSWORD@proxy.example.com:8080/";
Acquire::ftp::Proxy "http://USERNAME:PASSWORD@proxy.example.com:8080/";
```

Update packages:

```
sudo apt update
```

------

## 3. Set Proxy for Current Shell Session

For a one-time temporary proxy:

```
export http_proxy="http://proxy.example.com:8080/"
export https_proxy="http://proxy.example.com:8080/"
```

Remove proxy for session:

```
unset http_proxy
unset https_proxy
```

------

## 4. Set Persistent Proxy for Bash Users

Edit your user’s `.bashrc`:

```
nano ~/.bashrc
```

Add:

```
export http_proxy="http://proxy.example.com:8080/"
export https_proxy="http://proxy.example.com:8080/"
export no_proxy="localhost,127.0.0.1"
```

Reload:

```
source ~/.bashrc
```

------

## 5. Configure Proxy for Snap (Optional)

```
sudo snap set system proxy.http="http://proxy.example.com:8080"
sudo snap set system proxy.https="http://proxy.example.com:8080"
```

Remove snap proxy:

```
sudo snap set system proxy.http=
sudo snap set system proxy.https=
```

------

## 6. Verify Proxy

Check environment variables:

```
env | grep -i proxy
```

Check APT proxy:

```
grep -i proxy /etc/apt/apt.conf.d/*
```

------

## 7. Disable All Proxies

Remove or comment the lines from:

- `/etc/environment`
- `/etc/apt/apt.conf.d/95proxies`
- `~/.bashrc`

Then reload:

```
source /etc/environment
source ~/.bashrc
```