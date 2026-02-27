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
    HandleLidSwitch = "ignore";
  };
  # don’t shutdown when power button is short-pressed
  services.logind.settings.Login.HandlePowerKey = "ignore";
  # want to be able to listen to music while laptop closed
  # services.logind.settings.Login.LidSwitchIgnoreInhibited = "no";

  # services.upower.ignoreLid = true; # Didn't work
  # services.logind.extraConfig = ''
  #   # don’t shutdown when power button is short-pressed
  #   HandlePowerKey=ignore
  #   HandleSuspendKey=ignore
  #   HandleHibernateKey=ignore
  # '';

  environment.systemPackages = [ pkgs.heroic ];
}
