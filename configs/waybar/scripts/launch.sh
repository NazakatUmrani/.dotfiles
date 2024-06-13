#!/usr/bin/env bash

killall waybar
pkill waybar
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css
