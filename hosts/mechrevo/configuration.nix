{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
  ];

  my.mounts.ntfs.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.steam.enable = true;

  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  # services.xserver.videoDivers = [ "amdgpu" ];

  environment.systemPackages = [ pkgs.heroic ];
}
