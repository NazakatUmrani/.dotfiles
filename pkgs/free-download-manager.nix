{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  makeWrapper,
  udev,
  libdrm,
  libpqxx,
  unixODBC,
  gst_all_1,
  xorg,
  libpulseaudio,
  mysql80,
  xcb-util-cursor,
}:

stdenv.mkDerivation rec {
  pname = "freedownloadmanager";
  version = "6.21.0.5639";

  src = fetchurl {
    url = "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb";
    hash = "sha256-EbcMkEr7uMiBRBUu1KM4CBKi3Vm0FgCqSK205Kw9CiQ=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs =
    [
      libdrm
      libpqxx
      unixODBC
      stdenv.cc.cc
      mysql80
      xcb-util-cursor
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-libav
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ])
    ++ (with xorg; [
      xcbutilwm # libxcb-icccm.so.4
      xcbutilimage # libxcb-image.so.0
      xcbutilkeysyms # libxcb-keysyms.so.1
      xcbutilrenderutil # libxcb-render-util.so.0
      libpulseaudio
    ]);

  autoPatchelfIgnoreMissingDeps = [ "libmimerapi.so" ]; # not in nixpkgs yet

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt/freedownloadmanager $out
    cp -r usr/share $out
    ln -s $out/freedownloadmanager/fdm $out/bin/${pname}
    wrapProgram $out/bin/${pname} --set QT_QPA_PLATFORM xcb

    substituteInPlace $out/share/applications/freedownloadmanager.desktop \
      --replace 'Exec=/opt/freedownloadmanager/fdm' 'Exec=${pname}' \
      --replace "Icon=/opt/freedownloadmanager/icon.png" "Icon=$out/freedownloadmanager/icon.png"
  '';

  meta = with lib; {
    description = "A smart and fast internet download manager";
    homepage = "https://www.freedownloadmanager.org";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
  };
}