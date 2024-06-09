#!/usr/bin/env bash
[ -d ~/.cache/wlogout ] || mkdir -p ~/.cache/wlogout
grim ~/.cache/wlogout/shot.png
magick ~/.cache/wlogout/shot.png --blur 0x8 ~/.cache/wlogout/shot.png
wlogout -p layer-shell