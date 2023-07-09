---
title: "Personal Linux Post Install"
date: 2022-06-15T00:33:04-03:00
draft: false
type: post
---

Just some notes to to everytime I changed Linux distribution for some reason.

## Software Access
- [Install Flatpak support](https://flatpak.org/setup/)
- [Install Snap support](https://snapcraft.io/docs/installing-snapd)
- [Install and configure AppImage Support](https://github.com/TheAssassin/AppImageLauncher/wiki/Install-on-Ubuntu-or-Debian)

## Install Software

### Snaps
- aws-cli
- bitwarden
- chromium
- codium
- dbeaver-ce
- discord
- ffmpeg
- gimp
- go
- insomnia
- hugo
- nextcloud-desktop-client
- node
- slack
- terraform
- youtube-dl
- zoom-client
- xournalpp

### Flatpaks
- Flatseal
- OBS Studio
- Steam
- FreeTube
- RetroArch

### System packages
- docker
- docker-compose
- flameshot
- steam-devices
- git
- ansible
- dkms
- pwgen
- adb 
- fastboot
- android-sdk-platform-tools-common
- gdebi
- [NVM](https://github.com/nvm-sh/nvm)
- [Xone](https://github.com/medusalix/xone)
- [input-remapper](https://github.com/sezanzeb/input-remapper)
- [Upwork Desktop](https://www.upwork.com/ab/downloads/?os=linux)
- [Google Chrome](https://www.google.com/chrome/index.html)

### Python packages
- black -> `sudo pip3 install black`
- flake8 -> `sudo pip3 install flake8`

### Node packages
- serverless -> `sudo npm install -g serverless`

### Gnome Extensions
- [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/)
- [Sound Input & Output Device Chooser](https://extensions.gnome.org/extension/906/sound-output-device-chooser/)
- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)

## Configure System
- settings -> keyboard -> shortcuts -> mouse3 (lateral button) to mute microphone
- settings -> keyboard -> shortcuts -> printscreen to `flameshot gui`
- Enable dark mode
- Configure displays
- Dock -> Disable unmounted volumes

### Input Remapper Configuration
- F4 -> `Shift_L + backslash`
- F3 -> `backslash`

### Possible solution for CS:GO disconnecting
- [https://github.com/ValveSoftware/csgo-osx-linux/issues/2590](https://github.com/ValveSoftware/csgo-osx-linux/issues/2590)
- sdr_spew_level 0
- Disable wifi, keep only wired connection active

## Restore Backup
- [Install and configure Timeshift](https://github.com/teejee2008/timeshift)
- Restore Backup from NAS Server, configure new $HOME backup

### Current Backup Configuration
Folders to Back Up:
- Home

Folders do Ignore:
- ~/.var
- ~/Nextcloud
- ~/Downloads
- ~/snap
- ~/.cache
- Trash

## Post Install
- Download Steam Games
- Login on Firefox and configure Extensions
- Gnome Online Accounts configuration
- Configure Thunderbird
- [Fix Codium golang path](https://github.com/golang/vscode-go/issues/1411)
- Generate VPN Keys if needed
- Enjoy :)
