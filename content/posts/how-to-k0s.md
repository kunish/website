---
title: "How to k0s"
date: "2021-11-16"
description: "How to deploy kubernetes cluster inside your homelab in under 10 minutes"
---

# What Is [K0S](https://k0sproject.io)

The Simple, Solid & Certified Kubernetes Distribution

# Prerequisites

- Linux Server (64bit is recommended, I'll use three raspberrypi 4's with ubuntu 20.04 installed here as a example)
- SSH client credential, password or ssh key (ssh key is prefered)

# Lets get the bussiness going

1. Install k0sctl on your local machine

```shell
wget -O /usr/local/bin/k0sctl https://github.com/k0sproject/k0sctl/releases/latest/download/k0sctl-darwin-x64
```

2. Configuration file

Write a file named `k0sctl.yml` or `k0sctl.yaml`, and the content should looks like below

```yml
apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
  name: k0s-cluster

spec:
  hosts:
    - ssh:
        address: pi1
        user: kunish
        keyPath: ~/.ssh/homelab_id_rsa
      role: controller

    - ssh:
        address: pi2
        user: kunish
        keyPath: ~/.ssh/homelab_id_rsa
      role: worker

    - ssh:
        address: p3
        user: kunish
        keyPath: ~/.ssh/homelab_id_rsa
      role: worker

  k0s:
    extensions:
      helm:
        repositories:
          - name: metallb
            url: https://metallb.github.io/metallb

          - name: ingress-nginx
            url: https://kubernetes.github.io/ingress-nginx
        charts:
          # load balancer
          - name: metallb
            chartname: metallb/metallb
            namespace: metallb-system
            createNamespace: true
            values: |2
              configInline:
                address-pools:
                - name: cluster-arp-pool
                  protocol: layer2
                  addresses:
                  - 10.10.50.0-10.10.50.255

          # ingress controller
          - name: ingress-nginx
            chartname: ingress-nginx/ingress-nginx
            namespace: ingress-nginx
            createNamespace: true
            values: |2
              controller:
                ingressClassResource:
                  default: true
```

3. Deploy

```shell
k0sctl apply
k0sctl kubeconfig > ~/.kube/config

chmod 600 ~/.kube/config
```

4. Test

```shell
kubectl cluster-info
```

# Cleanup

```shell
k0sctl reset
```

# Summary

As you can see, the deployment process is pretty simple and straight forward, that's why I like k0s

It's even much simpler compared to [k3s](https://k3s.io) and comes with nothing non-sense pre-installed unlike k3s (cattle,traefik,local-path-provisioner)

And it has been really stable no matter whatever I throw in it since the first day I get it up and running
