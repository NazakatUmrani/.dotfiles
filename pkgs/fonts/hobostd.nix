{ stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  name = "hobostd-font";
  src = fetchzip {
    url = "https://www.wfonts.com/download/data/2014/12/30/hobo-std/hobo-std.zip";
    sha256 = "+LROaFsiKZEo+BUTWCIZTP91bp249R0sPOSxOtawyPU=";
    stripRoot = false;
  };
  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp $src/*.otf $out/share/fonts/opentype/
  '';
  meta = {
    description = "Hobo Std font family";
    homepage = "https://www.freefontsfamily.com/hobostd-font/";
  };
}
