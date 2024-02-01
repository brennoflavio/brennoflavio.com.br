---
title: "Personal Linux Post Install"
date: 2024-02-01T09:33:04-03:00
draft: false
type: post
---

Just some notes to to everytime I changed Linux distribution for some reason.

## Software Access
- [Install Snap support](https://snapcraft.io/docs/installing-snapd)
- [Install and configure AppImage Support](https://github.com/TheAssassin/AppImageLauncher/wiki/Install-on-Ubuntu-or-Debian)

## Install Software

### Snaps
- aws-cli
- bitwarden
- bruno
- cheese
- chromium
- code
- dbeaver-ce
- deja-dup
- discord
- electronplayer
- element-desktop
- ffmpeg
- gimp
- go
- google-cloud-cli
- hugo
- inkscape
- libreoffice
- newsflash
- nextcloud-desktop-client
- node
- slack
- spotify
- teams-for-linux
- telegram-desktop
- terraform
- thunderbird
- vlc
- whatsapp-linux-app
- xournalpp
- zoom-client


### System packages
atuin
curl
direnv
docker (from website)
findutils
gdebi
git
gnome-browser-connector
gnome-calendar
gnome-tweaks
gnome-weather
howdy (from github)
input-remapper
libmysqlclient-dev
minecraft-launcher (from website)
mongodb-compass (from website)
piper
pipx
ppa-purge
pwgen
steam-launcher (from website)
timeshift
- [NVM](https://github.com/nvm-sh/nvm)
- [input-remapper](https://github.com/sezanzeb/input-remapper)
- pipx

### Pipx packages
- black
- flake8
- argcomplete
- notebook
- poetry
- pre-commit

### Gnome Extensions
- [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/)
- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)

## Configure System
- settings -> keyboard -> shortcuts -> mouse3 (lateral button) to mute microphone
- Enable dark mode
- Configure displays
- Dock -> Disable unmounted volumes

### Input Remapper Configuration
- F4 -> `Shift_L + backslash`
- F3 -> `backslash`

### Possible solution for CS:GO disconnecting
- Turn off wifi when using ethernet connection

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
- Generate VPN Keys if needed
- Enjoy :)
