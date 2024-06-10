{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  pname = "atomic-grub";
  version = "0.1.1";
  src = pkgs.fetchurl {
    url = "https://github.com/NazakatUmrani/Grub-Themes/releases/latest/download/Atomic.tar.gz";
    sha256 = "E5jf1NQ4wJwtnYaY2Fqfy0Bq5J7Zf0f0sPPut8F8YHo=";
  };
  unpackPhase="mkdir $out && tar -xvf $src -C $out";
}