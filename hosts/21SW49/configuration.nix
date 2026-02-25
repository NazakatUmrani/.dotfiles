{ config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
    ../../modules/grub.nix
  ];
}
