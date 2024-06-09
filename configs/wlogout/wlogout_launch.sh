#!/usr/bin/env bash
grim /tmp/shot.png
magick /tmp/shot.png --blur 0x8 /tmp/shot.png
wlogout -p layer-shell