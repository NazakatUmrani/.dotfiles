{ config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
    ../../modules/grub.nix
  ];

  environment.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "/home/nazakat/WindowsData/Screenshots & Recordings";
  };
}
