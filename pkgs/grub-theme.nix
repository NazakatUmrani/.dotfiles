{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  pname = "atomic-grub";
  version = "0.1.1";
  src = pkgs.fetchurl {
    url = "https://github.com/NazakatUmrani/Grub-Themes/releases/latest/download/Atomic.tar.gz";
    sha256 = "Kk4vkBYyUDL4kN3RRYAKJYwozq0c+pfEqT6B+7kiFr0=";
  };
  unpackPhase="mkdir $out && tar -xvf $src -C $out";
}