{ config, username, inputs, pkgs, ... }:
{
  # Allow Unfree Softwares
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "nix-2.15.3" ];
  };

  # Nix Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    nixd # Nix language server required by nix zed extension
    nixpkgs-fmt # formatter nix files
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  programs.nix-ld.enable = true; # No idea what it is (Something related to FHS and library linking or like that stuff)
}
