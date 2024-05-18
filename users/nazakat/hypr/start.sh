#!/usr/bin/env bash

# wallpaper
swww init
~/.config/hypr/wallpaperSetter.sh init

# Network Manager Applet
nm-applet --indicator &

# Add the bar
waybar &

# dunst
dunst
