{
  config,
  pkgs,
  inputs,
  username,
  ...
}:

{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  programs = {
    discord.enable = true;
    firefox.enable = true;
    gpg.enable = true;
    kitty = {
      enable = true;
      package = pkgs.kitty;
    };
    obs-studio.enable = true;
    rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
      ];
    };
    vscode.enable = true;
    waybar.enable = true; # Highly customizable Wayland bar
    wlogout.enable = true; # Wayland based logout menu
    zed-editor.enable = true; # Zed Code Editor
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
    };
    swww.enable = true; # Wallpaper daemon for wayland
  };
}
