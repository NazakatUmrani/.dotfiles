{ config, pkgs, ... }:

{
  programs.kitty.enable = true; # Highly customizable Wayland bar

  xdg = {
    configFile."kitty" = {
      source = ../../configs/kitty;
      recursive = true;
    };
  };
}
