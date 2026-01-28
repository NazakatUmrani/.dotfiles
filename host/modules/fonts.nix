{ config, pkgs, ... }:
let
  google-fonts = (pkgs.google-fonts.override {
    fonts = [
      # to see font names, github.com/google/fonts and search for the font folder, there in it's METADATA file you will see it's correct name to put here
      "Grape Nuts"
    ];
  });

  impact = pkgs.callPackage ../../pkgs/fonts/impact.nix {};
  hobostd = pkgs.callPackage ../../pkgs/fonts/hobostd.nix {};
in
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      fira-code

      # Fonts for rofi styles
      iosevka
      icomoon-feather
      google-fonts
      font-awesome
      impact
      hobostd

      # Maple Mono
      maple-mono.NF
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}
