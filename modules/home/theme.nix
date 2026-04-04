{ config, pkgs, ... }:
let
  gtk-css = "@import '../../configs/GTK/gtk.css'";
in
{
  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.numix-cursor-theme;
    name = "Numix-Cursor";
    size = 24;
  };

  # GTK
  gtk = {
    enable = true;
    font = {
      name = "MapleMono-NF";
      size = 12;
      package = pkgs.maple-mono.NF;
    };

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    iconTheme = {
      package = pkgs.gruvbox-plus-icons;
      name = "Gruvbox Plus Dark";
    };

    gtk3 = {
      extraCss = gtk-css;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      theme = null;
      extraCss = gtk-css;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "Breeze";
    };
  };
}
