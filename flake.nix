{
  description = "My First Flake for NixOS System Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Neovim configuration framework
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs = inputs@{ nixpkgs, home-manager, nvf, nixos-hardware, ... }:
  let
    system = "x86_64-linux"; #System
    hostname = "21SW49";
    username = "nazakat";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = false; };
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      "${hostname}" = lib.nixosSystem {
        specialArgs = {
          inherit system inputs hostname username;
        };

        modules = [
          ./host/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = {
              inherit username inputs hostname;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./host/home.nix;
          }
          nvf.nixosModules.default
          nixos-hardware.nixosModules.dell-latitude-5490
        ];
      };
    };
  };
}
