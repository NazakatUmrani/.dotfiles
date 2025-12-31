{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alarm-clock-applet
    # android-studio
    # android-tools
    audacity
    bat
    bluez
    bluez-tools
    bottles
    brightnessctl
    btop
    celluloid
    clang
    clang-tools
    cliphist
    cmake
    discord
    dunst
    feh
    fish
    flameshot
    # (pkgs.callPackage ../../pkgs/free-download-manager.nix {}) # Not Working because of new updates and dependencies
    gcc
    gdb
    gh
    gimp # Photo Editing Software
    git #VCS
    # github-desktop
    google-chrome # Secondary Broweser
    grimblast # A helper for screenshots within Hyprland, based on grimshot
    grim # Grab images from a Wayland compositor
    gsettings-desktop-schemas
    handbrake # Video Converter
    hugo
    hyprpaper # Hyprland Wallpaper utility
    imagemagick
    inkscape # Vector Editing software
    # jdk
    kazam
    kdePackages.partitionmanager
    killall
    lf
    libinput-gestures
    libnotify
    libreoffice-fresh
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.kget
    kdePackages.okular
    kdePackages.polkit-kde-agent-1
    libsForQt5.qt5ct
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtquickcontrols2
    kdePackages.qtwayland
    lldb
    # lutris
    # lua-language-server
    luajit
    # lvim
    mako
    mongodb-compass # MongoDB Compass GUI
    neofetch
    networkmanagerapplet
    nix-output-monitor # beautiful nix build loading screen
    nixpkgs-fmt # formatter nix files
    nodejs_24
    nodePackages.nodemon
    nomacs
    nvd # compare two nix configurations
    nwg-look
    obs-studio
    onlyoffice-desktopeditors
    openboard
    papirus-icon-theme
    pavucontrol
    pipewire
    polkit
    python3
    # python311Packages.streamlit
    qalculate-qt
    qemu
    qt6Packages.qtstyleplugin-kvantum
    qt6.qtwayland
    qtcreator
    ranger
    remmina
    ripgrep # dependency of nvim for live grep using telescope
    #rnix-lsp  package removed in latest branch
    rPackages.settings
    slurp
    streamlit
    swappy
    swaylock-effects
    swww
    sxhkd
    teamviewer
    telegram-desktop
    tldr
    tree
    unzip
    ventoy-full-qt
    vim
    vimPlugins.clangd_extensions-nvim
    vimPlugins.coc-pyright
    vimPlugins.nvim-dap
    vimPlugins.nvim-dap-ui
    # vimPlugins.null-ls-nvim
    vlc
    # vmware-workstation
    vscode
    # (vscode-with-extensions.override {
    #   vscodeExtensions = with vscode-extensions; [
    #     llvm-vs-code-extensions.vscode-clangd
    #     mkhl.direnv
    #     ms-vscode.cpptools-extension-pack
    #     formulahendry.code-runner
    #   ];
    # })
    waybar
    waydroid
    waypaper
    wget
    wine
    wireplumber
    wl-clipboard
    wlogout
    xdg-desktop-portal-hyprland
    xsettingsd
    yazi
    zed-editor # A lightweight, blazingly fast code editor
    # palworld wine dependency
    # bubblewrap
    # dwarfs
    # fuse-overlayfs
    # gamescope
  ];
}
