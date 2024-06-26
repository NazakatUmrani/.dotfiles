# Edit this configuration file to define what should be installed on

# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, hostname, username, inputs, ... }:
let
  google-fonts = (pkgs.google-fonts.override { fonts = [
      "Grape Nuts"
      # # Sans
      # "Gabarito" "Lexend"
      # # Serif
      # "Chakra Petch" "Crimson Text"
    ];
  });
in  
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/grub.nix
    ./modules/systemPackages.nix
    ./modules/sound.nix
    ./modules/virtualisation.nix
  ];

  networking = {
    hostName = "${hostname}"; # Define your hostname.
    # Pick only one of the below networking options.
    networkmanager.enable = true;
    # networking.wireless.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #  useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services = {
    # ------- List services that you want to enable: -------
    # teamviewer.enable = true;
    libinput.enable = true; # Touchpad support
    openssh.enable = true; # OpenSSH daemon.

    # Display Manager
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${import ../pkgs/sddm-theme.nix { inherit pkgs; }}";
      };
    };

    # Configure keymap in X11
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    # printing.enable = true;
  };

  # Enabling Hyprland
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    nix-ld.enable = true; # No idea what it is
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
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
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    #XDG_CURRENT_DESKTOP = "Hyprland";
    #XDG_SESSION_DESKTOP = "Hyprland";
    #XDG_SESSION_TYPE = "wayland";
    #GDK_BACKEND = "wayland";
    #GTK_USE_PORTAL = "1";
    #QT_QPA_PLATFORM = "wayland";
    #MOZ_ENABLE_WAYLAND = "1";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "distrobox"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    #shell = pkgs.fish;
    #ignoreShellProgramCheck = true; # Allows to ignore checking as fish is declared in home.nix
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerdfonts
      fira-code
      # Fonts for rofi styles
      iosevka
      icomoon-feather
      google-fonts
      # font-awesome
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system = {
    copySystemConfiguration = false; # can't set it to true, becuase of flake
    stateVersion = "23.11"; # Don't change it manually?
  };
}
