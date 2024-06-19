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
themes_path="$HOME/.config/rofi/themes"

# ----------------------------------------------------- 
# Initialize arrays
# ----------------------------------------------------- 
# listThemes=""
listNames=""
# listNames2=""

# ----------------------------------------------------- 
# Read theme folder
# -----------------------------------------------------
# Read theme folder
# -----------------------------------------------------
sleep 0.2 
while IFS= read -r -d $'\0' value; do
  if [ ! "$value" == "$themes_path" ]; then
    result=$(echo "$value" | sed "s#$HOME/.config/rofi/themes/##g" | sed "s/.rasi//g")
    listNames+="${result}\n"
  fi
done < <(find "$themes_path" -print0)
listNames=${listNames::-2}


# ----------------------------------------------------- 
# Show rofi dialog
# ----------------------------------------------------- 
# listNames=${listNames::-2}
choice=$(echo -e "${listNames}" | sort | rofi -dmenu -replace -i -config ~/.config/rofi/config.rasi -no-show-icons -width 30 -p "Rofi Themes")

symFile="${HOME}/.config/kitty/config.rasi"

if [ -n "$choice" ]; then
  rm $symFile || echo "Can't delete"
  ln -s "${themes_path}/${choice}.rasi" $symFile
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

