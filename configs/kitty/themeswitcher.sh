#!/usr/bin/env bash
#  _____ _                                       _ _       _                
# |_   _| |__   ___ _ __ ___   ___  _____      _(_) |_ ___| |__   ___ _ __  
#   | | | '_ \ / _ \ '_ ` _ \ / _ \/ __\ \ /\ / / | __/ __| '_ \ / _ \ '__| 
#   | | | | | |  __/ | | | | |  __/\__ \\ V  V /| | || (__| | | |  __/ |    
#   |_| |_| |_|\___|_| |_| |_|\___||___/ \_/\_/ |_|\__\___|_| |_|\___|_|    
#                                                                           
# by Stephan Raabe (2024) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Default theme folder
# ----------------------------------------------------- 
themes_path="$HOME/.config/kitty/themes"

# ----------------------------------------------------- 
# Initialize arrays
# ----------------------------------------------------- 
# listThemes=""
# listNames=""
# listNames2=""

# ----------------------------------------------------- 
# Read theme folder
# -----------------------------------------------------
# sleep 0.2 
# options=$(find $themes_path -maxdepth 2 -type d)
# for value in $options
# do
#     if [ ! $value == "$HOME/dotfiles/waybar/themes/assets" ]; then
#         if [ ! $value == "$themes_path" ]; then
#             if [ $(find $value -maxdepth 1 -type d | wc -l) = 1 ]; then
#                 result=$(echo $value | sed "s#$HOME/dotfiles/waybar/themes/#/#g")
#                 IFS='/' read -ra arrThemes <<< "$result"
#                 listThemes[${#listThemes[@]}]="/${arrThemes[1]};$result"
#                 if [ -f $themes_path$result/config.sh ]; then
#                     source $themes_path$result/config.sh
#                     listNames+="$theme_name\n"
#                     listNames2+="$theme_name~"
#                 else
#                     listNames+="/${arrThemes[1]};$result\n"
#                     listNames2+="/${arrThemes[1]};$result~"
#                 fi
#             fi
#         fi
#     fi
# done

# ----------------------------------------------------- 
# Show rofi dialog
# ----------------------------------------------------- 
# listNames=${listNames::-2}
choice=$(echo -e "Catppuccin-Latte\nCatppuccin-Mocha\nCyberpunk-Edge\nDecay-Green\ndiff\ndracula\nFrosted-Glass\nGraphite-Mono\ngruvbox_dark\ngruvbox_dark_hard\ngruvbox_dark_soft\ngruvbox_light\ngruvbox_light_hard\ngruvbox_light_soft\nGruvbox-Retro\nMaterial-Sakura\nMyTheme\nRose-Pine\nTokyo-Night" | rofi -dmenu -replace -i -config ~/.config/rofi/config.rasi -no-show-icons -width 30 -p "Themes")

symFile="${HOME}/.config/kitty/theme.conf"

if [ -n "$choice" ]; then
  if [ -f $symFile ]; then
    rm $symFile
  fi
  ln -s "${themes_path}/${choice}.conf" $symFile
  notify-send "Kitty theme updated" "Theme: ${choice}"
else
  notify-send "No theme selected"
fi

# IFS="~"
# input=$listNames2
# read -ra array <<< "$input"

# ----------------------------------------------------- 
# Set new theme by writing the theme information to ~/.cache/.themestyle.sh
# ----------------------------------------------------- 
# if [ "$choice" ]; then
#     echo "Loading waybar theme..."
#     echo "${listThemes[$choice+1]}" > ~/.cache/.themestyle.sh
#     ~/dotfiles/waybar/launch.sh
#     notify-send "Waybar Theme changed" "to ${array[$choice]}"
# fi

