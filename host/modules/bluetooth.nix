{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true; # Blueman (Bluetooth Manager)
  environment.systemPackages = with pkgs; [
    # bluez
    # bluez-tools
  ];
}
