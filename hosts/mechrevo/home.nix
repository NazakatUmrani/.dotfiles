{ config, ... }:

{
  imports = [
    ../../modules/home
  ];

  # Hyprland Monitor custom option scale
  my.hyprland = {
    monitor.scale = 1.25;
    # enableAnimations = true;
    enableBlur = true;
    enableShadow = true;
    enableBorders = true;
  };
}
