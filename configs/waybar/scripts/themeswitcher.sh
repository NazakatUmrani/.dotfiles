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
# Initialize arrays
# ----------------------------------------------------- 
listNames="Kitty\nRofi"

# ----------------------------------------------------- 
# Show rofi dialog
# ----------------------------------------------------- 
choice=$(echo -e "${listNames}" | sort | rofi -dmenu -replace -i -config ~/.config/rofi/config.rasi -no-show-icons -width 30 -p "Themes Switcher")

if [ -n "$choice" ]; then
  if [ "$choice" == "Kitty" ]; then
    ~/.config/kitty/themeswitcher.sh
  elif [ "$choice" == "Rofi" ]; then
    ~/.config/rofi/themeswitcher.sh
  fi
else
  notify-send "No option selected"
fi
