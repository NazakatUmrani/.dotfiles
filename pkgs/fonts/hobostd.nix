{ stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  name = "hobostd-font";
  src = fetchzip {
    url = "https://www.wfonts.com/download/data/2014/12/30/hobo-std/hobo-std.zip";
    sha256 = "17cp5xd9icnhbs1zniv6iag3z254wnb58rvlvqsqa4gpa7w7dzkv";
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
