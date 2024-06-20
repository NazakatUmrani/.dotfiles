#!/usr/bin/env bash

wall=$(find ~/Pictures/Wallpapers/ -type f -name "*.jpg" -o -name "*.png" | shuf -n 1)

swww query || swww-daemon --format xrgb && swww img "$wall" --transition-step 59 --transition-fps 30 --transition-type grow --transition-pos 1285,100
wal -i "$wall"

# update terminal colors
symFile="${HOME}/.config/kitty/theme.conf"
if [ -f $symFile ]; then
	rm $symFile
fi
ln -s "${HOME}/.cache/wal/colors-kitty.conf" $symFile

# cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors-waybar.css

# ~/.config/waybar/scripts/launch.sh init  &

notify-send "Theme and wallpaper updated" "Wallpaper: $(echo $wall | sed 's|/home/nazakat/Pictures/Wallpapers/||g')"


# swww img /home/nazakat/Pictures/Wallpapers/rebellious_tower.png --transition-step 59 --transition-fps 30 --transition-type grow --transition-pos 1285,100 &
