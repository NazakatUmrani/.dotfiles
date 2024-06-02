#!/usr/bin/env bash
pushd ~/.dotfiles
sudo nixos-rebuild switch --flake ./#
popd
