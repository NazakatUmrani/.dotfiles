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

      "neofetch/config.conf".source = ../../configs/neofetch/config.conf;

      "swaylock/config".source = ../../configs/swaylock/config;
    };
  };

  home.file = {
    ".bashrc".source = ../../configs/.bashrc;
    ".vimrc".source = ../../configs/.vimrc;
    ".face.icon".source = ../../configs/face.png;
  };
}
