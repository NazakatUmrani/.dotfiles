{ config, pkgs, username, host, ... }:

let
  gruvboxPlus = import ./gruvbox-plus.nix { inherit pkgs; };
  gtk-css = "@import './gtk.css'";
in
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

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

  programs = {
    gpg.enable = true;
    firefox.enable = true;
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      # plugins = [ pkgs.rofi-emoji pkgs.rofi-calc ];
    };
  };
  xdg.configFile."rofi/config.rasi" = {
    text = builtins.readFile ./rofi/config.rasi;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

   # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # GTK
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
      package = pkgs.ubuntu_font_family;
    };

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
    
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";
    
    iconTheme.package = gruvboxPlus;
    iconTheme.name = "GruvboxPlus";

    gtk3 = {
      extraCss = gtk-css;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraCss = gtk-css;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

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
      V = ''%${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';
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

    eza
    git-crypt
    gnupg
    pinentry-qt
  ];

  home.file = {
    ".bashrc".source = ./.bashrc;
    ".vimrc".source = ./.vimrc;

    # neofetch files
    ".config/neofetch" = {
      source = ./neofetch;
      recursive = true;
    };
    
    # hyprland files
    ".config/hypr" = {
      source = ./hypr;
      recursive = true;
    };
    
    # kitty files
    ".config/kitty" = {
      source = ./kitty;
      recursive = true;
    };

    # Waybar files
    ".config/waybar" = {
      source = ./waybar;
      recursive = true;
    };

    # Wlogout files
    ".config/wlogout" = {
      source = ./wlogout;
      recursive = true;
    };

    # Nvim Files
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };

  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
