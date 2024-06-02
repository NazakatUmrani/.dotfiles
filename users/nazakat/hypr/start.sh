#!/usr/bin/env bash

# wallpaper
swww-daemon --format xrgb &
~/.config/hypr/wallpaperSetter.sh init

# Network Manager Applet
nm-applet --indicator &

# Add the bar
waybar &

# dunst
dunst
