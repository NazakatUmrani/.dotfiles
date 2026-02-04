{ config, lib, pkgs, hostname, username, inputs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules
  ];

  hardware = {
    graphics = {
      enable = true;
      # driSupport = true;
      extraPackages = with pkgs; [
        # mesa mesa.drivers libva
        # intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl
      ];
    };
  };

  # Zen Kernel (Testing if it gives better performance)
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Performance mode
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # Enable the X11 windowing system.
  services = {
    # ------- List services that you want to enable: -------
    # teamviewer.enable = true; # Temporarily disable it
    libinput.enable = true; # Touchpad support
    openssh.enable = true; # OpenSSH daemon

    seatd.enable = true;

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Openvpn
    # openvpn.servers = {
    #   azureVpn = { config = '' config /home/nazakat/openvpn/azurevpn.conf ''; };
    # };
  };

  # Enabling Hyprland
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    nix-ld.enable = true; # No idea what it is

    appimage.enable = true; # Enable AppImage support
    appimage.binfmt = true; # binfmt registration to run appimages via appimage-run seamlessly.
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    EDITOR = "nvim";
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    # GTK_USE_PORTAL = "1";
    # QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  security = {
    pam.services.swaylock = { }; # password isn't accepted, if removed
    polkit.enable = true; # Enable Polkit
  };

  # Allow Unfree Softwares
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "nix-2.15.3" ];
  };
  # Nix Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users = {
    defaultUserShell = pkgs.fish;
    users = {
      root.initialPassword = "123";
      ${username} = {
        initialPassword = "123";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
          "distrobox"
          "audio"
        ]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [ ];
        # ignoreShellProgramCheck = true; # Allows to ignore checking as fish is declared in home.nix
      };
    };
  };

  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "23.11"; # Don't change it manually?
}
