#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./NixOS/users/nazakat/home.nix
popd
