{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hyprland-mac-style";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "NazakatUmrani";
    repo = "Mac-style-Plymouth-theme-for-Hyprland";
    rev = "9e160d3720d3fa10f742b0a7f5d52bd9d298bdd2";
    sha256 = "1s943rrg8m9rb8r73387nbp9pncwvw4lmwd15y2wj2sgh5wgnnji";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/share/plymouth/themes/hyprland-mac-style
    cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/hyprland-mac-style/
    substituteInPlace $out/share/plymouth/themes/hyprland-mac-style/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/hyprland-mac-style/images"
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mac-style Plymouth theme for Hyprland";
    homepage = "https://github.com/NazakatUmrani/Mac-style-Plymouth-theme-for-Hyprland";
    license = licenses.gpl3; # Verify the actual license
    platforms = platforms.all;
  };
}