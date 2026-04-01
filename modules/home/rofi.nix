{ config, pkgs, ... }:

{
  programs = {
    rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
      ];
    };
  };

  xdg = {
    configFile."rofi" = {
      source = ../../configs/rofi;
      recursive = true;
    };
  };
}
