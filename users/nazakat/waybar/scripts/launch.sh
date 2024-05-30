#!/usr/bin/env bash

killall waybar
pkill waybar
sleep 0.5
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css
