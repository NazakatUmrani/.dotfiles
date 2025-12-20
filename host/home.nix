{ config, pkgs, inputs, username, ... }:

let
  gtk-css = "@import '../configs/GTK/gtk.css'";
in
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  programs = {
    # Setting Git configs
    git = {
      enable = true;
      settings = {
        user = {
          name = "Nazakat Umrani - NixOS Linux";
          email = "unazakat70@gmail.com";
        };
        init.defaultBranch = "main";
        http.version = "HTTP/1.1"; # solves some curl fail EOF, issues
        safe.directory = "/home/nazakat/WindowsData/Projects/SmartFix-AI-Driven-Technician-Booking-Platform";
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [ xclip wl-clipboard ];
    };
    gpg.enable = true;
    firefox.enable = true;
    fish.enable = true;
    rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
      ];
    };
    lf = {
      enable = true;
      commands = {
        # Changed from xdragon to dragon-out which gives 2 options: xdragon and dragon-drop, right now using xdragon, not sure about dragon-drop yet
        dragon-out = ''%${pkgs.dragon-drop}/bin/xdragon -a -x "$fx"'';
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
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    configFile = {
      "kitty" = {
        source = ../configs/kitty;
        recursive = true;
      };
      "hypr" = {
        source = ../configs/hypr;
        recursive = true;
      };
      "rofi" = {
        source =  ../configs/rofi;
        recursive = true;
      };
      "lf/icons".source = ../configs/lf/icons;
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

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
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
      name = "kvantum-dark";
    };
  };

  
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # plugins = [
      # hyprplugins.hyprtrails
    # ];
    extraConfig = " ";
  };
  
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })    
    eza
    git-crypt
    gopeed # Download Manager
    gnupg
    kdePackages.dolphin
    motrix # Download Manager
    pinentry-qt
    pywal
    varia # Download Manager
    xfce.thunar
  ];

  home.file = {
    ".bashrc".source = ../configs/.bashrc;
    ".vimrc".source = ../configs/.vimrc;
    ".face.icon".source = ../configs/face.png;

    # neofetch config file
    ".config/neofetch/config.conf".source = ../configs/neofetch/config.conf;

    # Swaylock files
    ".config/swaylock/config".source = ../configs/swaylock/config;
    
    # Dunst files
    ".config/dunst" = {
      source = ../configs/dunst;
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

  # # Session variables
  # home.sessionVariables = {
  #   EDITOR = "nvim";
  # };
}
