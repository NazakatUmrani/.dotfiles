{
  description = "My First Flake for NixOS System Dotfiles";

  inputs = {
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  # outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, ... }: 
  outputs = inputs@{ nixpkgs, home-manager, ... }: 
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
          # {
          #   nixpkgs.overlays = [
          #     (final: prev: {
          #       unstable = nixpkgs-unstable.legacyPackages.${prev.system};
          #     })
          #   ];
          # }
          # chaotic.nixosModules.default
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
          # nixos-hardware.nixosModules.dell-latitude-5490
        ];
      };
    };
  };
}
