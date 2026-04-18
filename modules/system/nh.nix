{ config, username, pkgs, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/${username}/.dotfiles"; # sets NH_OS_FLAKE variable for you
  };

  environment.systemPackages = with pkgs; [
    # No need to add separately, but I wanted them so I can run these independently if needed
    nix-output-monitor # beautiful nix build loading screen
    nvd # compare two nix configurations
  ];
}
