#!/usr/bin/env bash

wall=$(find ~/Pictures/Wallpapers/ -type f -name "*.jpg" -o -name "*.png" -o -name "*.gif" | shuf -n 1)
swww img $wall --transition-step 255 &

wal -c
wal -i $wall

# updates terminal colors
# source "$HOME/.cache/wal/colors.sh"

cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors-waybar.css

~/.config/waybar/scripts/launch.sh init

notify-send "Theme and wallpaper updated" "Wallpaper: $wall"


# swww img /home/nazakat/Pictures/Wallpapers/rebellious_tower.png --transition-step 59 --transition-fps 30 --transition-type grow --transition-pos 1285,100 &
