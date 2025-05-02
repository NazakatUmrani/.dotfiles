{ stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  name = "impact-font";
  src = fetchzip {
    url = "https://font.download/dl/font/impact.zip";
    sha256 = "08dc2b12dpiajim0j0azk0y149mgar3s87gmvgrjahp9yzdkvqgz";
    stripRoot = false;
  };
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/*.ttf $out/share/fonts/truetype/
  '';
  meta = {
    description = "Impact font family";
    homepage = "https://font.download/font/impact/";
  };
}
