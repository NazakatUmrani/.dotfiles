{ config, pkgs, username, host, ... }:

let
  gruvboxPlus = import ../pkgs/gruvbox-plus.nix { inherit pkgs; };
  gtk-css = "@import '../configs/GTK/gtk.css'";
in
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

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
      plugins = with pkgs;
      map (pkg: pkg.override { rofi-unwrapped = rofi-wayland-unwrapped; }) [
        rofi-emoji
        rofi-calc
      ];
    };
  };
  xdg.configFile."rofi/config.rasi" = {
    text = builtins.readFile ../configs/rofi/config.rasi;
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

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
    
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    
    iconTheme = {
      package = gruvboxPlus;
      name = "GruvboxPlus";
    };

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
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/*" = [ "sxiv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };

  xdg.configFile."lf/icons".source = ../configs/lf/icons;
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
      V = ''''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';
      dd = "delete";
      # ...
    };

    settings = {
      preview = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    extraConfig = 
    let 
      previewer = 
        pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5
        
        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
        fi
        
        ${pkgs.pistol}/bin/pistol "$file"
      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in
    ''
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${previewer}/bin/pv.sh
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [ xclip wl-clipboard ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      # hyprplugins.hyprtrails
    ];
  };

  programs.fish.enable = true;

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })    
    eza
    git-crypt
    gnupg
    # kdePackages.dolphin
    pinentry-qt
    xfce.thunar
  ];

  home.file = {
    ".bashrc".source = ../configs/.bashrc;
    ".vimrc".source = ../configs/.vimrc;
    ".face.icon".source = ../configs/face.png;

    # neofetch config file
    ".config/neofetch/config.conf".source = ../configs/neofetch/config.conf;
    
    # hyprland files
    ".config/hypr" = {
      source = ../configs/hypr;
      recursive = true;
    };
    
    # kitty files
    ".config/kitty" = {
      source = ../configs/kitty;
      recursive = true;
    };

    # Waybar files
    ".config/waybar" = {
      source = ../configs/waybar;
      recursive = true;
    };

    # Wlogout files
    ".config/wlogout" = {
      source = ../configs/wlogout;
      recursive = true;
    };

    # Nvim Files
    ".config/nvim" = {
      source = ../configs/nvim;
      recursive = true;
    };

  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}