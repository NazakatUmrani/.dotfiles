{ config, pkgs, ... }:
let
  hyprlandMacPlymouth = pkgs.callPackage ../../pkgs/hyprland-mac-style-plymouth.nix {};
in
{
  # Solves the TPM issue (A start job is running 90 seconds wait on boot)
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;

  # Plymouth
  boot = {
    kernelParams = ["quiet"]; # Debugging info off while booting
    plymouth = {
      enable = true;
      theme = "hyprland-mac-style";
      themePackages = [ hyprlandMacPlymouth ];
    };
  };

  # Nixos Boot Plymouth Theme using another flake
  # nixos-boot = {
  #   enable = true;
  #   # Black background
  #   bgColor.red = 0;
  #   bgColor.green = 0;
  #   bgColor.blue = 0;
  # };
}
