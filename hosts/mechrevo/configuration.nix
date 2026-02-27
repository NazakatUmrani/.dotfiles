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
  # boot.loader.grub.efiInstallAsRemovable = true; # GRUB will install in EFI/boot/boot$arch.efi which the firmwares are hardcoded to try first.

  programs.steam.enable = true;

  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    # HandleLidSwitch = "ignore";
  };

  environment.systemPackages = [ pkgs.heroic ];
}
