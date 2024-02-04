#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/nazakat/home.nix
popd
