{ config, ... }:

{
  programs.waybar.enable = true; # Highly customizable Wayland bar

  xdg.configFile."waybar" = {
    source = ../../configs/waybar;
    recursive = true;
  };
}
