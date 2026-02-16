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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
    system = "x86_64-linux";
    username = "nazakat";
    lib = nixpkgs.lib;

    # Host builder function
    mkHost = { hostname, hostPath, extraModules ? [ ] }:
      lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs username hostname;
        };

        modules =
          [
            hostPath

            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs =
                { inherit username inputs hostname; };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${username} =
                import ./hosts/common/home.nix;
            }

            nvf.nixosModules.default
          ]
          ++ extraModules;
      };

  in {
    nixosConfigurations = {

      # Dell
      "21SW49" = mkHost {
        hostname = "21SW49";
        hostPath = ./hosts/21SW49/configuration.nix;
        extraModules = [
          nixos-hardware.nixosModules.dell-latitude-5490
        ];
      };

      # Mechrevo
      "mechrevo" = mkHost {
        hostname = "mechrevo";
        hostPath = ./hosts/mechrevo/configuration.nix;
      };
    };
  };
}