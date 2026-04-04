{ config, username, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/${username}/.dotfiles"; # sets NH_OS_FLAKE variable for you
  };
}
