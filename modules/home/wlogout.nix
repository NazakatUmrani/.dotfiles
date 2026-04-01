{ config, ... }:

{
  programs.wlogout.enable = true; # Highly customizable Wayland bar

  xdg.configFile."wlogout" = {
    source = ../../configs/wlogout;
    recursive = true;
  };
}
