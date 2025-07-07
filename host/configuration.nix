# Edit this configuration file to define what should be installed on

# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, hostname, username, inputs, ... }:
let
  google-fonts = (pkgs.google-fonts.override {
    fonts = [
      "Grape Nuts" # to see font names, github.com/google/fonts and search for the font folder, there in it's METADATA file you will see it's correct name to put here
    ];
  });

  impact = pkgs.callPackage ../pkgs/fonts/impact.nix {};
  hobostd = pkgs.callPackage ../pkgs/fonts/hobostd.nix {};
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

  fileSystems."/home/nazakat/WindowsData" = {
    device = "/dev/disk/by-uuid/E2CE55C2CE559021";
    fsType = "ntfs";
    options = ["rw" "uid=nazakat" "gid=users"];
  };

  fileSystems."/home/nazakat/Nazakat Umrani" = {
    device = "/dev/disk/by-uuid/688E1D518E1D1960";
    fsType = "ntfs";
    options = ["rw" "uid=nazakat" "gid=users"];
  };

  #hardware.graphics = {
  #  package = pkgs.unstable.mesa.drivers;
  #};
  hardware = {
    graphics = {
      enable = true;
      # driSupport = true;
      extraPackages = with pkgs; [
        # mesa mesa.drivers libva
        # intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl
      ];
    };
    bluetooth.enable = true; # enables support for Bluetooth
  };

  # Performance mode
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

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

  # systemd.services.nix-daemon.environment = {
  #   # socks5h mean that the hostname is resolved by the SOCKS server
  #   # https_proxy = "socks5h://localhost:7891";
  #   https_proxy = "http://localhost:7890"; # or use http prctocol instead of socks5
  # };

  # Solves the TPM issue (A start job is running 90 seconds wait on boot)
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;

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
    teamviewer.enable = true;
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
    
    seatd.enable = true;

    # Configure keymap in X11
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      #videoDrivers = [ "intel" ];
    };

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
      # xwayland.enable = true;
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
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    # GTK_USE_PORTAL = "1";
    # QT_QPA_PLATFORM = "wayland";
    # MOZ_ENABLE_WAYLAND = "1";
  };

  security = {
    pam.services.swaylock = { }; # password isn't accepted, if removed
    polkit.enable = true; # Enable Polkit
  };

  # Allow Unfree Softwares
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "nix-2.15.3" "ventoy-1.1.05"];
  };
  # Nix Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.defaultUserShell = pkgs.fish;
  users.users.root.initialPassword = "123";
  users.users.${username} = {
    initialPassword = "123";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "distrobox"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    # shell = pkgs.fish;
    # ignoreShellProgramCheck = true; # Allows to ignore checking as fish is declared in home.nix
  };

  programs.fish.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      fira-code
      # Fonts for rofi styles
      iosevka
      icomoon-feather
      google-fonts
      font-awesome
      impact
      hobostd
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };

  # Hyprland not launching
  # chaotic.mesa-git.enable = true;

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
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 5000 3000 5173 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 5173; to = 5174; }
      { from = 8000; to = 8010; }
    ];
  };

  system = {
    copySystemConfiguration = false; # can't set it to true, becuase of flake
    stateVersion = "23.11"; # Don't change it manually?
  };
}
