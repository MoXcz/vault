---
author: ["Oscar Marquez"]
title: "Load balancing with nginx"
description: "How to create a load balancer using Nginx"
pubDate: "2026-05-03"
tags:
  - nginx
  - php
  - network
---

# Load balancing with `nginx`

[Load balancing](https://www.cloudflare.com/learning/performance/what-is-load-balancing/) is the process of distributing traffic across multiple servers with the intent of increasing performance and reliability.
![load-balancer](/img/load-balancer.svg)

The software in charge of balancing the traffic can be a general-purpose web server acting as a reverse proxy, like [nginx](https://nginx.org/), or a dedicated load balancer like [HAProxy](http://www.haproxy.org/).

The purpose of this guide is to build a load balancer using Docker and nginx, and to keep it at the bare minimum I will make use of three machines, the minimum necessary to make use of a load balancer:

- Server A: The load balancer
- Server B: Backend server 1
- Server C: Backend server 2

## Setting up B and C

The backend will make use of `nginx` + `php-fpm`. In this case I used Docker as I always install it on any of my servers or personal machines. This was the `compose.yml` file I used:

```yaml
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "420:80"
    volumes:
      - ./app:/var/www/html
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php

  php:
    image: php:8.5-fpm
    container_name: php
    volumes:
      - ./app:/var/www/html
```

And the `default.conf` file for `nginx`:

```nginx
server {
    listen 80;
    server_name localhost;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

Just make sure to put the PHP files inside `./app`, or change the volume for the PHP service in the `compose.yml` file.

## Setting up A

For A, we somehow need to tell it where to route the traffic to. In order to do this is first necessary to know the IP addresses of both B and C. Log into those machines and run:

```bash
ip a
```

Look for the `inet` address under your primary network interface (e.g., `eth0` or `wlan0`). Note both IPs down (for example, `10.0.0.2` and `10.0.0.3`).

With the IPs of B and C, now create the `default.conf` file for `nginx`, specifying these IPs on an `upstream` block. Note that by default `nginx` uses a [Round Robin](https://en.wikipedia.org/wiki/Round-robin) algorithm (see below):

```nginx
upstream php_backend {
    # Replace these IPs with the ones from 'ip a'
    server <SERVER_B_IP>:420;
    server <SERVER_C_IP>:420;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://php_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

And the `compose.yml` file used (for this one you could just `docker run nginx` the thing):

```yaml
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "420:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
```

> To start any of the `compose.yml` files run: docker compose up -d

And that's it. If everything was done correctly you should be able to search the IP of A and on refresh get either a response from B or C. You could easily verify this by just including different applications with something like `Hi from B` and `Hi from C`.

## Extras

### Firewall

This might not work correctly if you have set up a firewall. I use `ufw` on my machines, and for this specific case you can just allow the port:

```sh
sudo ufw allow 420
```

### Algorithms for balancing

There are different algorithms that can be used for `nginx` to balance traffic:

- Round-robin. The default, will alternate between servers.
- Weighted round-robin. Variant of round-robin where each server has an assigned priority (weight).
- Least connections. Will send request to the server with the least amount of active connections at that moment.
- IP hash. Assigns to each incoming IP to a server and always routes that IP to that server.

You can assign these values on `default.conf` in the `upstream` block, for example, IP hash would look like this:

```nginx
upstream php_backend {
    ip_hash;
    server <SERVER_B_IP>:420;
    server <SERVER_C_IP>:420;
}
```

## The end

You can actually very easily transform this to use anything other than PHP, but PHP was recently used in one of my classes, so there's that. To change it just transform the server from `nginx` + `php-fpm` to whatever you want (e.g., Go, Apache, Caddy).

You can check out the repository of this blog post in [GitHub](https://github.com/MoXcz/load-balancing-with-nginx).
