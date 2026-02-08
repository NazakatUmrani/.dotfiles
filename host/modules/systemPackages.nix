{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    audacity
    bat
    bottles
    brightnessctl
    btop
    clang
    clang-tools
    cliphist
    cmake
    dunst
    feh
    # (pkgs.callPackage ../../pkgs/free-download-manager.nix {}) # Not Working because of new updates and dependencies
    gh
    git #VCS
    git-crypt
    # github-desktop
    grimblast # A helper for screenshots within Hyprland, based on grimshot
    grim # Grab images from a Wayland compositor
    gsettings-desktop-schemas
    # jdk
    kdePackages.partitionmanager
    killall
    lf
    libnotify
    kdePackages.polkit-kde-agent-1
    libsForQt5.qt5ct
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtquickcontrols2
    kdePackages.qtwayland
    lldb
    # lutris
    mongodb-compass # MongoDB Compass GUI
    nil # Nix language server required by nix zed extension
    nitch
    nixd # Nix language server required by nix zed extension
    fastfetch
    networkmanagerapplet
    nix-output-monitor # beautiful nix build loading screen
    nixpkgs-fmt # formatter nix files
    nodejs_24
    nodePackages.nodemon
    nvd # compare two nix configurations
    nwg-look # GTK settings editor
    papirus-icon-theme
    polkit
    qt6Packages.qtstyleplugin-kvantum
    qt6.qtwayland
    ranger
    remmina # Remote desktop client written in GTK
    slurp # Select a region in a Wayland compositor
    swaylock-effects
    tldr # too long didn't read
    tree
    unzip
    vim
    wget
    wl-clipboard
    xdg-desktop-portal-hyprland
    xsettingsd
    yazi
    # palworld wine dependency
    # bubblewrap
    # dwarfs
    # fuse-overlayfs
    # gamescope
  ];
}
