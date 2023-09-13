---
title: "How to run Invidious in a FreeBSD Jail"
date: 2023-09-13T20:11:00-03:00
draft: false
type: post
---

Invidious is a YouTube frontend replacement, meaning that you have all YouTube content without using its UI, which
is full of tracking and ads. So it's a simpler way to consume its content sharing less data as possible. [You can learn
more here](https://invidious.io/).

But if you run a FreeBSD server (like me that runs a TrueNas Core NAS), you'll find out that there are only Linux
installation processes in their documentation. I tried self-hosting it in a Jail a few months ago, without any success.
This week I found out [on this issue](https://github.com/iv-org/invidious/issues/2388#issuecomment-1715130282)
that someone was able to host it in a FreeBSD installation. So I tried it out by myself, and it worked as expected.

So, for documentation purposes, I'm copying the steps in the issue here so more people can see it.

Install dependencies:

```
pkg install shards crystal postgresql15-server ImageMagick7-nox11 librsvg2 git sqlite3 nano
```

Enable postgres:
```
sysrc postgresql_enable=yes
```

First-time setup:
```
/usr/local/etc/rc.d/postgresql initdb
```

Start it:
```
service postgresql start
```

Open the configuration file and enable password login.
First, open the configuration file:
```
cd /var/db/postgres/data15
nano pg_hba.conf
```

At the end of the file, you'll see something like
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust  
# IPv6 local connections:
host    all             all             ::1/128                 trust 
```

You need to change the `METHOD` OF ipv4 and ipv6 local connections to `md5`.
It will look like this:

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5  
# IPv6 local connections:
host    all             all             ::1/128                 md5 
```

Save, close and restart Postgres
```
ctrl + x and enter to save
service postgresql restart
```

Now you can create a new database user, and database and set permissions:
```
su - postgres
psql
```

Inside psql:
```
create database invidious;
create user kemal with superuser password '<strong password here>';
grant all privileges on database invidious to kemal;
exit
```

Now exit again to return to your user, download and build Invidious
```
git clone https://github.com/iv-org/invidious
cd invidious
shards install --production
crystal build src/invidious.cr --release
cp config/config.example.yml config/config.yml
```

You'll need to edit the configuration file to fill your needs. At minimum fill in the database
information.
```
nano config/config.yml
```

Now you can test it by running:
```
./invidious --migrate
./invidious
```

You should be able to browse Invidious normally!

To run it as a service, I use runit. You can install it and some dependencies:
```
pkg install runit bash

mkdir /var/service
cp -R /usr/local/etc/runit /etc/runit
echo runsvdir_enable=yes >> /etc/rc.conf
service runsvdir start
```

Create a startup script inside the Invidious directory
```
cd /root/invidious
nano start.sh
```

Adjust and paste a similar content to this:
```
cd /root/invidious
./invidious
```

Grant proper permissions:
```
chmod +x start.sh
```

Now create service directory and file:
```
mdkir /var/service/invidious
nano /var/service/invidious/run
```

Adjust and paste a similar content to this:
```
#!/bin/sh -e
exec 2>&1
exec /usr/local/bin/bash /root/invidious/start.sh
```

Grant proper permissions:
```
chmod +x start.sh
```

And start the service
```
sv start invidious
```

You can check services running by port to make sure everything is up:
```
sockstat -l4 -P tcp
```
