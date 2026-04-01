{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Download Manager
    gopeed
    motrix
    varia

    # Media Apps
    celluloid
    handbrake # Video Converter
    vlc

    eza
    gimp # Photo Editing Software
    gnupg
    google-chrome # Secondary Broweser
    hyprpaper # Hyprland Wallpaper utility
    inkscape # Vector Editing software
    libreoffice-fresh
    kdePackages.dolphin
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.kget
    kdePackages.okular
    libinput-gestures
    nomacs # Image Viewer
    onlyoffice-desktopeditors
    openboard
    pinentry-qt
    pywal
    qalculate-qt
    qtcreator
    telegram-desktop
    thunar
    waypaper # GUI wallpaper setter for Wayland-based window managers
  ];
}
