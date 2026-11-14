{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/system
  ];

  my.mounts.ntfs.enable = false;

  boot.loader.timeout = 2;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.efiInstallAsRemovable = true; # GRUB will install in EFI/boot/boot$arch.efi which the firmwares are hardcoded to try first.

  boot.loader.systemd-boot.consoleMode = "max";

  programs.steam.enable = true;

  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  # Failing to boot after April 2026, default is broker, but our old one was dbus, so it was failing to switch, only could do nixos rebuild boot, but then the new entry won't boot as well, it would be broken, so for now, setting it to dbus old one
  services.dbus.implementation = "dbus";

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    # HandleLidSwitch = "ignore";
  };

  environment.systemPackages = [ pkgs.heroic ];

  environment.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "/home/nazakat/Pictures/Screenshots & Recordings";
  };
}
