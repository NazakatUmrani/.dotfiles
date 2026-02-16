{ config, pkgs, ... }:

{
  # Display Manager
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        kdePackages.qtmultimedia
        kdePackages.qtsvg
        kdePackages.qtvirtualkeyboard
      ];
    };
  };

  # Package
  environment.systemPackages = with pkgs; [
    (sddm-astronaut.override {
      embeddedTheme = "black_hole";
    })
  ];
}
