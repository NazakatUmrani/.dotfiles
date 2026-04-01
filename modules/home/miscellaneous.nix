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
    obs-studio.enable = true;
    vscode.enable = true;
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
