# !/usr/bin/env bash

# initializing wallpaper daemon
swww init &

nm-applet --indicator &

# waybar
waybar &

# dunst
dunst
