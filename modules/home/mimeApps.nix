{ config, ... }:

{
  mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/*" = [ "sxiv.desktop" ];
    "video/png" = [ "vlc.desktop" ];
    "video/jpg" = [ "vlc.desktop" ];
    "video/*" = [ "vlc.desktop" ];
  };
}
