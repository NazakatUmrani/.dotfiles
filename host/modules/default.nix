{
  imports = [
    ./bluetooth.nix
    ./fonts.nix
    ./grub.nix
    ./locales.nix
    ./mountpoints.nix
    ./network.nix
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
