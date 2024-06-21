---
title: "Using a DSLR camera as your webcam on Linux"
date: 2024-06-21T11:11:00-03:00
draft: false
type: post
---

Recently I bought a Canon 60D with the objective ot it being my primary webcam. I found some [good articles](https://austingil.com/dslr-webcam-linux/) on how to setup it,
however I did some improvements to enhance the experience so I'm going to share my full tutorial here.

## Setup

- Camera: Canon EOS 60D
- Operating System: Ubuntu 22.04

## Dependencies

Install gphoto2, v4l2loopback, and ffmpeg

```
sudo apt install gphoto2 v4l2loopback-utils v4l2loopback-dkms ffmpeg
```

## Setup Dummy device

You're going to edit the file `/etc/modules` to add `v4l2loopback` into it.

```
sudo nano /etc/modules
```

It will be like:
```
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.
v4l2loopback
```

After that create a new file to configure the webcam:

```
sudo nano /etc/modprobe.d/v4l2loopback.conf
```

and add the following line

```
options v4l2loopback devices=1 max_buffers=2 exclusive_caps=1 card_label="VirtualCam"
```

Reboot, and you should see your dummy device by running:

```
v4l2-ctl --list-devices
```

```
VirtualCam (platform:v4l2loopback-000):
	/dev/video0
```

`/dev/video0` might be different for you, take note on this.

## Camera service

I created a simple python script and a systemd service to automate camera setup. It will retry stablishing a connection
with the camera every 5 seconds.

First create the python file:

```
sudo mkdir -p /etc/camera-manager
sudo nano /etc/camera-manager/main.py
```

Add the following code into it
```
import subprocess
import time
import logging

while True:
    subprocess.run("gphoto2 --stdout autofocusdrive=1 --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0", shell=True)
    logging.info("lost camera, waiting")
    time.sleep(5)
```

Find your python execution path
```
which python3
```

Then create the service:
```
sudo nano /etc/systemd/system/camera.service
```

Don't forget to adjust the `User` and `ExecStart`
```
[Unit]
Description=camera
After=network.target

[Service]
User=brenno
Type=simple
ExecStart=/home/brenno/.pyenv/shims/python3 /etc/camera-manager/main.py 

# Restart every >2 seconds to avoid StartLimitInterval failure
RestartSec=5
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start the service
```
sudo systemctl daemon-reload
sudo systemctl enable camera.service
sudo systemctl start camera.service
```

Now you should have a working camera at boot, without any manual configuration
