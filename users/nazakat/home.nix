{ config, pkgs, username, host, ... }:

let
  gruvboxPlus = import ./gruvbox-plus.nix { inherit pkgs; };
  gtk-css = "@import './gtk.css'";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Setting Git configs
  programs.git = {
    enable = true;
    userName = "Nazakat Umrani - NixOS Linux";
    userEmail = "unazakat70@gmail.com";
  };

  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
  };

  programs.gpg = {
    enable = true;
  };

  programs.rofi = {
    enable = true;
    plugins = [pkgs.rofi-emoji pkgs.rofi-calc];
  };
  xdg.configFile."rofi/config.rasi" = {
    text = builtins.readFile ./rofi/config.rasi;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # GTK
  gtk = {
    enable = true;

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
    
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";
    
    iconTheme.package = gruvboxPlus;
    iconTheme.name = "GruvboxPlus";

    gtk3.extraCss = gtk-css;
    gtk4.extraCss = gtk-css;
  };
  
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/*" = [ "sxiv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };

  xdg.configFile."lf/icons".source = ./lf/icons;
  programs.lf = {
    enable = true;
    commands = {
      dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
      editor-open = ''$$EDITOR $f'';
      mkdir = ''
      ''${{
        printf "Directory Name: "
        read DIR
        mkdir $DIR
      }}
      '';
    };

    keybindings = {

      "\\\"" = "";
      o = "";
      c = "mkdir";
      "." = "set hidden!";
      "`" = "mark-load";
      "\\'" = "mark-load";
      "<enter>" = "open";
      
      do = "dragon-out";
      
      "g~" = "cd";
      gh = "cd";
      "g/" = "/";

      ee = "editor-open";
      V = ''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';
      dd = "delete";
      # ...
    };

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    git-crypt
    gnupg
    pinentry-qt
    eza
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".bashrc".source = ./.bashrc;
    ".vimrc".source = ./.vimrc;
    # ".config/gtk-4.0/gtk.css".source = ./gtk.css;
   
    # neofetch files
    ".config/neofetch/config.conf".source = ./neofetch/config.conf;
    ".config/neofetch/gifs/cat.gif".source = ./neofetch/gifs/cat.gif;
    ".config/neofetch/gifs/pochita.gif".source = ./neofetch/gifs/pochita.gif;
    ".config/neofetch/gifs/pokemon.gif".source = ./neofetch/gifs/pokemon.gif;
    ".config/neofetch/gifs/tales.gif".source = ./neofetch/gifs/tales.gif;
    ".config/neofetch/pngs/arch.png".source = ./neofetch/pngs/arch.png;
    ".config/neofetch/pngs/hyprdots.png".source = ./neofetch/pngs/hyprdots.png;
    ".config/neofetch/pngs/pochita.png".source = ./neofetch/pngs/pochita.png;

    # hyprland files
    ".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
    ".config/hypr/start.sh".source = ./hypr/start.sh;
    ".config/hypr/wallpaperSetter.sh".source = ./hypr/wallpaperSetter.sh;
    
    # kitty files
    ".config/kitty/kitty.conf".source = ./kitty/kitty.conf;
    ".config/kitty/themes/Catppuccin-Latte.conf".source = ./kitty/themes/Catppuccin-Latte.conf;
    ".config/kitty/themes/Catppuccin-Mocha.conf".source = ./kitty/themes/Catppuccin-Mocha.conf;
    ".config/kitty/themes/Cyberpunk-Edge.conf".source = ./kitty/themes/Cyberpunk-Edge.conf;
    ".config/kitty/themes/Decay-Green.conf".source = ./kitty/themes/Decay-Green.conf;
    ".config/kitty/themes/Frosted-Glass.conf".source = ./kitty/themes/Frosted-Glass.conf;
    ".config/kitty/themes/Graphite-Mono.conf".source = ./kitty/themes/Graphite-Mono.conf;
    ".config/kitty/themes/Gruvbox-Retro.conf".source = ./kitty/themes/Gruvbox-Retro.conf;
    ".config/kitty/themes/gruvbox_dark.conf".source = ./kitty/themes/gruvbox_dark.conf;
    ".config/kitty/themes/gruvbox_dark_hard.conf".source = ./kitty/themes/gruvbox_dark_hard.conf;
    ".config/kitty/themes/gruvbox_dark_soft.conf".source = ./kitty/themes/gruvbox_dark_soft.conf;
    ".config/kitty/themes/gruvbox_light.conf".source = ./kitty/themes/gruvbox_light.conf;
    ".config/kitty/themes/gruvbox_light_hard.conf".source = ./kitty/themes/gruvbox_light_hard.conf;
    ".config/kitty/themes/gruvbox_light_soft.conf".source = ./kitty/themes/gruvbox_light_soft.conf;
    ".config/kitty/themes/Material-Sakura.conf".source = ./kitty/themes/Material-Sakura.conf;
    ".config/kitty/themes/Rose-Pine.conf".source = ./kitty/themes/Rose-Pine.conf;
    ".config/kitty/themes/theme.conf".source = ./kitty/themes/theme.conf;
    ".config/kitty/themes/Tokyo-Night.conf".source = ./kitty/themes/Tokyo-Night.conf;

    # Waybar files
    ".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
    ".config/waybar/style.css".source = ./waybar/style.css;
    ".config/waybar/scripts/keyhint.sh".source = ./waybar/scripts/keyhint.sh;
    ".config/waybar/scripts/mediaplayer.py".source = ./waybar/scripts/mediaplayer.py;
    ".config/waybar/scripts/PBPbattery.sh".source = ./waybar/scripts/PBPbattery.sh;
    ".config/waybar/scripts/power-meny.sh".source = ./waybar/scripts/power-menu.sh;
    ".config/waybar/scripts/weather.sh".source = ./waybar/scripts/weather.sh;
    ".config/waybar/scripts/launch.sh".source = ./waybar/scripts/launch.sh;

    # Wlogout files
    ".config/wlogout/layout_1".source = ./wlogout/layout_1;
    ".config/wlogout/layout_2".source = ./wlogout/layout_2;
    ".config/wlogout/style_1.css".source = ./wlogout/style_1.css;
    ".config/wlogout/style_2.css".source = ./wlogout/style_2.css;
    ".config/wlogout/icons/hibernate_black.png".source = ./wlogout/icons/hibernate_black.png;
    ".config/wlogout/icons/hibernate_white.png".source = ./wlogout/icons/hibernate_white.png;
    ".config/wlogout/icons/lock_black.png".source = ./wlogout/icons/lock_black.png;
    ".config/wlogout/icons/lock_white.png".source = ./wlogout/icons/lock_white.png;
    ".config/wlogout/icons/logout_black.png".source = ./wlogout/icons/logout_black.png;
    ".config/wlogout/icons/logout_.png".source = ./wlogout/icons/logout_white.png;
    ".config/wlogout/icons/reboot_back.png".source = ./wlogout/icons/reboot_black.png;
    ".config/wlogout/icons/reboot_white.png".source = ./wlogout/icons/reboot_white.png;
    ".config/wlogout/icons/shutdown_black.png".source = ./wlogout/icons/shutdown_black.png;
    ".config/wlogout/icons/shutdown_white.png".source = ./wlogout/icons/shutdown_white.png;
    ".config/wlogout/icons/suspend_black.png".source = ./wlogout/icons/suspend_black.png;
    ".config/wlogout/icons/suspend_white.png".source = ./wlogout/icons/suspend_white.png;

    # Nvim Files
    ".config/nvim/init.lua".source = ./nvim/init.lua;
    ".config/nvim/lua/options.lua".source = ./nvim/lua/options.lua;
    ".config/nvim/lua/plugins.lua".source = ./nvim/lua/plugins.lua;
    ".config/nvim/lua/pluginlist.lua".source = ./nvim/lua/pluginlist.lua;
    ".config/nvim/after/plugin/lsp.lua".source = ./nvim/after/plugin/lsp.lua;
    ".config/nvim/after/plugin/cmp.lua".source = ./nvim/after/plugin/cmp.lua;
    ".config/nvim/after/plugin/telescope.lua".source = ./nvim/after/plugin/telescope.lua;
    ".config/nvim/after/plugin/treesitter.lua".source = ./nvim/after/plugin/treesitter.lua;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nazakat/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
