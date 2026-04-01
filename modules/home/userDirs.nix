{ config, ... }:

{
  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    configFile = {
      "dunst" = {
        source = ../../configs/dunst;
        recursive = true;
      };

      "kitty" = {
        source = ../../configs/kitty;
        recursive = true;
      };

      "lf/icons".source = ../../configs/lf/icons;

      "neofetch/config.conf".source = ../../configs/neofetch/config.conf;

      "rofi" = {
        source = ../../configs/rofi;
        recursive = true;
      };

      "swaylock/config".source = ../../configs/swaylock/config;

      "waybar" = {
        source = ../../configs/waybar;
        recursive = true;
      };

      "wlogout" = {
        source = ../../configs/wlogout;
        recursive = true;
      };
    };

    mimeApps.defaultApplications = {
      "text/plain" = [ "neovide.desktop" ];
      "application/pdf" = [ "zathura.desktop" ];
      "image/*" = [ "sxiv.desktop" ];
      "video/png" = [ "vlc.desktop" ];
      "video/jpg" = [ "vlc.desktop" ];
      "video/*" = [ "vlc.desktop" ];
    };
  };

  home.file = {
    ".bashrc".source = ../../configs/.bashrc;
    ".vimrc".source = ../../configs/.vimrc;
    ".face.icon".source = ../../configs/face.png;
  };
}
