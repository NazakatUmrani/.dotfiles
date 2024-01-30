#!/bin/sh
pushd ~/.dotfiles
sudo nixos-rebuild switch -I nixos-config=./NixOS/system/configuration.nix
popd
