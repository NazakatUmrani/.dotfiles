{
  description = "My First Flake for NixOS System Dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux"; #System
    host = "21SW49";
    username = "nazakat";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = false; };
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      "${host}" = lib.nixosSystem {
        specialArgs = {
          inherit system inputs host username;
        };

        modules = [
          ./system/configuration.nix   
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = {
              inherit username inputs host;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./users/${username}/home.nix;
          }
        ];
      };
    };
  };
}
