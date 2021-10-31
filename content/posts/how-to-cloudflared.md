---
title: "How to cloudflared"
date: "2021-10-31"
description: "How to use cloudflared (argo tunnel) as a reverse proxy to bypass CGNAT"
---

# Prerequisite

- cloudflare account
- cloudflare hosted dns name
- linux machine

# Prepare

## Login to your linux machine via ssh

```shell
ssh workstation
```

## Installation

Download and install the latest release version

```shell
wget -q https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb

sudo dpkg -i $(basename $_)
```

Check if the installation is successful

```shell
command -v cloudflared
```

If you see the output is something like `/usr/local/bin/cloudflared`, you should be good to go

## Authentication

Get authentication certificate files via cloudflared command

```shell
cloudflared tunnel login
```

After issuing this command, you should see something like this

```
A browser window should have opened at the following URL:

https://dash.cloudflare.com/argotunnel?callback=https%3A%2F%2Flogin.cloudflareaccess.org%2xxx

If the browser failed to open, please visit the URL above directly in your browser.
```

As the description says, just copy and paste the url into your browser address bar and hit Enter

You will be directed to a cloudflare dashboard page, prompting you to choose a domain name to route the traffic to

After choosing the one you want to use, a file called `cert.pem` will be downloaded under `$HOME/.cloudflared` directory in your linux machine which we just copied the url from

Move this file into `/etc/cloudflared` directory which will be used by the `systemd` service

If you don't have this directory, just create a empty one

```shell
sudo mkdir /etc/cloudflared

sudo mv $HOME/.cloudflared/cert.pem $_
```

Create a new tunnel called `main` (you can name it whatever you want, just for illustration purpose here)

```shell
sudo cloudflared tunnel create main
```

```
Tunnel credentials written to /etc/cloudflared/e7ed42be-1234-5678-9fbf-c3d1d964cb67.json. cloudflared chose this file based on where your origin certificate was found. Keep this file secret. To revoke these credentials, delete the tunnel.

Created tunnel main with id e7ed42be-1234-5678-9fbf-c3d1d964cb67
```

The newly created certificate file `{UUID}.json` has been saved under `/etc/cloudflared` directory

## Configuration

Create a new file named exactly `config.yml` under `/etc/cloudflared`, and the content should be similar as the following:

```yaml
tunnel: e7ed42be-1234-5678-9fbf-c3d1d964cb67
credentials-file: /etc/cloudflared/e7ed42be-1234-5678-9fbf-c3d1d964cb67.json
ingress:
  - service: https://localhost
    originRequest:
      originServerName: shikun.info
```

## DNS Traffic Routing

Use cloudflared built-in dns cname command

```shell
sudo cloudflared tunnel route dns main ghost.shikun.info
```

## Start Systemd Service

```shell
sudo cloudflared service install

sudo systemctl enable --now cloudflared
```

## Troubleshooting

Checkout Systemd Logs

```shell
sudo journalctl -xefu cloudflared
```
