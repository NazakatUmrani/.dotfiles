{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "gruvbox-plus";
  
  src = pkgs.fetchurl {
    url = "https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v5.0.1/gruvbox-plus-icon-pack-5.0.1.zip";
    sha256 = "1wgqigibwd981l64hb8dm06ca9i6mfksix2prdkwfc8ciaa358zm";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    ${pkgs.unzip}/bin/unzip $src -d $out/
  '';
}
