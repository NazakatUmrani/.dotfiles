{
  imports = [
    ./bluetooth.nix
    ./fonts.nix
    ./locales.nix
    ./miscellaneous.nix
    ./mountpoints.nix
    ./network.nix
    ./nh.nix
    ./nix.nix
    ./nvf.nix
    ./plasma.nix
    ./plymouth.nix
    ./sddm.nix
    ./sound.nix
    ./systemPackages.nix

    # Temporarily Disabling Docker, Waydroid, Podman, Wine everything
    # ./virtualisation.nix
  ];
}
