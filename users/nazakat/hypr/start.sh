#!/usr/bin/env bash

# wallpaper
swww-daemon --format xrgb &
~/.config/hypr/wallpaperSetter.sh init

# Add the bar
waybar &

# Network Manager Applet
nm-applet --indicator &

# dunst
dunst
