{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  pname = "atomic-grub";
  version = "0.1.1";
  src = pkgs.fetchurl {
    url = "https://github.com/NazakatUmrani/Grub-Themes/releases/latest/download/Atomic.tar.gz";
    sha256 = "AXSoWh3KNKdIbuKxczT/xaNaGVDy2j45KZyrGAdy/lE=";
  };
  unpackPhase="mkdir $out && tar -xvf $src -C $out";
}