---
title: "Using Pihole as your DNS over TLS"
date: 2023-10-07T19:28:00-03:00
draft: false
type: post
---

If you have a Pi-hole installation in your home network and want to use it on your phone or other devices when you're out
of home, using a VPN is the recommended solution by PiHole Team. You can install OpenVPN in your Raspberry Pi using something
like [PiVPN](https://pivpn.io/), connect your phone to it and use your DNS securely across the world.

I don't like this setup, keeping a VPN alive on my phone does not seem ideal. In this tutorial, I'll show another
way to use PiHole on your Android Phone by relying on the Private DNS Feature.

## Private DNS

If you go to your phone settings, Network and Internet, you'll see a Private DNS section. Private DNS is the name that Android
gives for DNS over TLS (DOT), a type of DNS server that allows you querying DNS using a secure connection. There are may around,
and we'll build our own using Nginx and Pihole. In Android, you have 3 options:

- Off
- Automatic (Using Google DOT service)
- Private DNS provider hostname

For this tutorial, we'll generate this url to input in this field. You'll need:

- A domain name (like `brenoflavio.com.br`)
- A static ip that points to your router (some ISPs does not give that to you)
- Ability to do port forwarding in your router

## Setting up

First of all, we'll need to install Nginx in your Pihole. Assuming that you are using Raspbian, you can do that by running:

```
sudo apt install nginx
```

### lighttpd

If you installed Pihole web interface using `lighttpd`, nginx will conflict with it because both will listen to the port 80.

In this case you can forward port 80 in nginx to `lighttpd`. Go to its config folder and edit the config file:
```
cd /etc/lighttpd/
sudo nano lighttpd.conf
```

Change
```
server.port = 80
```

To
```
server.port = 8080
```

Save, close and restart `lighttpd` and `nginx`:
```
sudo service lighttpd restart
sudo service nginx restart
```

### router

In your router, you'll need to open some ports to generate the certificate and listen to DNS queries. Each router is different,
but you'll want to open:

- Port 80 poiting to your nginx ip
- Port 443 poiting to your nginx ip
- Port 853 poingint to your nginx ip

### domain

Once your ports are open, go to your domain provider and point your domain to your public IP. You want something like:

```
mydomain.example.com A <your public ipv4> 
```

If everyting worked correctly, you'll be able to access Nginx in your browser by going to:
```
http://<your public ip>
```

### certificate

Again each setup can have its certificate generated differently. On mine for example I have another NGINX to mange port 80 and I copy
the certificate from there to my raspberry pi. If you want to generate the cert in your Pi directly, you can use certbot for that.
I'll leave certbot documentation here:

[https://certbot.eff.org/instructions?ws=nginx&os=debianbuster](https://certbot.eff.org/instructions?ws=nginx&os=debianbuster)

Basically you want to install certbot and run its command to get a certificate for your domain configured above.

### nginx

Now we can configure Nginx. Go to its folder and edit the configuration file:
```
cd /etc/nginx/
sudo nano nginx.conf
```

In the end of this file, you want to add something like this:
```
stream {
    # DNS upstream pool
    upstream dns {
        zone dns 64k;
        server 127.0.0.1:53; # If NGINX is running in another machine, change this
    }

   # DoT server for decryption
   server {
        listen 853 ssl;
        ssl_certificate /etc/letsencrypt/live/<mydomain.example.com>/fullchain.pem; # Change to your certificate location
        ssl_certificate_key /etc/letsencrypt/live/<mydomain.example.com>/privkey.pem; # Change to your certificate location
        proxy_pass dns;
    }
}
```

If you want to keep accessing Pihole Web Interface on port 80, you can do that by changing the default site location:

```
sudo nano sites-enabled/default
```

Inside it, there is a location to the `/` path in the port `80`. Change it to be:
```
	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		# try_files $uri $uri/ =404;
                proxy_pass        http://localhost:8080;
                proxy_set_header  Host    $host;
                proxy_set_header  Connection keep-alive;
                proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
	}
```

Notice that this will open you Pihole web interface to the internet if you opened port 80 and pointed to your Pihole installation
before, which is not secure, so you might want to skip this.

### testing

You can test  your solution by running:

```
kdig @<dot_server> +tls-host=<tls_hostname> <domain_name>
```

For example:

```
kdig @mydomain.example.com +tls-host=mydomain.example.com google.com
```

And that's it! Go to your Private DNS settings and set the private dns as your domain. In Pihole, your phone queries will show
as `localhost` (or the hostname of your nginx installation)
