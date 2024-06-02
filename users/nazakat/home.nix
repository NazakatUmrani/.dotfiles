{ config, pkgs, username, host, ... }:

let
  gruvboxPlus = import ./gruvbox-plus.nix { inherit pkgs; };

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

    extraPackages = [
      
    ];
    
    plugins = [
      # treesitter
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.nvim-treesitter
      pkgs.vimPlugins.nvim-treesitter-textobjects
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java p.cpp ]))

      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.trouble-nvim
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.fidget-nvim

      ## cmp - completion
      pkgs.vimPlugins.nvim-cmp
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp-buffer
      pkgs.vimPlugins.cmp-cmdline

      pkgs.vimPlugins.clangd_extensions-nvim
      pkgs.vimPlugins.luasnip
      pkgs.vimPlugins.cmp_luasnip
      pkgs.vimPlugins.lspkind-nvim
      pkgs.vimPlugins.nvim-lint
      pkgs.vimPlugins.vim-surround
      pkgs.vimPlugins.vim-obsession
      pkgs.vimPlugins.kommentary
      pkgs.vimPlugins.neoformat
      pkgs.vimPlugins.lazygit-nvim
      pkgs.vimPlugins.gitsigns-nvim
      pkgs.vimPlugins.rainbow
      pkgs.vimPlugins.vim-sleuth
      pkgs.vimPlugins.lualine-nvim
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.lightspeed-nvim
      pkgs.vimPlugins.leap-nvim
      pkgs.vimPlugins.vim-repeat
      pkgs.vimPlugins.kanagawa-nvim

      ## Debugging
      pkgs.vimPlugins.nvim-dap
      pkgs.vimPlugins.nvim-dap-ui
      pkgs.vimPlugins.nvim-dap-virtual-text
    ];

    extraLuaConfig = ''
      vim,opt.number = true
      vim.opt.relativenumber = true
      
      require('telescope').setup()
      -- require('lspconfig.clangd').setup()
    '';

    extraConfig = ''
        lua << EOF
        ${builtins.readFile nvim/mappings.lua}
        ${builtins.readFile nvim/options.lua}
        ${builtins.readFile nvim/setup/cmp.lua}
        ${builtins.readFile nvim/setup/treesitter.lua}
        ${builtins.readFile nvim/setup/lspconfig.lua}
        ${builtins.readFile nvim/setup/luasnip.lua}
        ${builtins.readFile nvim/setup/trouble.lua}
        ${builtins.readFile nvim/setup/telescope.lua}
        ${builtins.readFile nvim/setup/kommentary.lua}
        ${builtins.readFile nvim/setup/lualine.lua}
        ${builtins.readFile nvim/setup/fidget.lua}
        ${builtins.readFile nvim/setup/lint.lua}
        ${builtins.readFile nvim/setup/leap.lua}
        ${builtins.readFile nvim/setup/gitsigns.lua}
        ${builtins.readFile nvim/setup/clangd_extensions.lua}
        ${builtins.readFile nvim/setup/dap.lua}
    '';

    # doesn't work
    # colorschemes.gruvbox.enable = true;
    # plugins.lightline.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello

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
    #".config/gtk-4.0/gtk.css".source = ./gtk.css;
   
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
    ".config/waybar/config".source = ./waybar/config;
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
