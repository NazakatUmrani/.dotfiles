# Edit this configuration file to define what should be installed on

# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
   device = "nodev";
   efiSupport = true;
   useOSProber = true;
   enable = true;
   extraEntries = ''
     # Shutdown
     menuentry "Shutdown" {
       halt
     }

     # Reboot
     menuentry "Reboot" {
       reboot
     }
   '';
#   theme = pkgs.nixos-grub2-theme;
   theme = "${
     (pkgs.fetchFromGitHub {
       owner = "NazakatUmrani";
       repo = "Grub-Themes";
       rev = "31edea9";
       sha256 = "6zspf9VAfwoDwMtjF/gL29IG8wMg8OmXwWUOQRn0xZw=";
     })
   }/Atomic/";
  };

  networking.hostName = "21SW49"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    displayManager = {
        sddm.enable = true;
        sddm.theme = "${import ../pkgs/sddm-theme.nix { inherit pkgs; }}";
    };
    xserver = { 
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      }; 
    };
  };

  #Virtulaization for waydroid
  virtualisation.waydroid.enable = true;
  #virtualisation for docker
  virtualisation.docker.enable = true;
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = false;

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enabling Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.sessionVariables = {
    # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    #XDG_CURRENT_DESKTOP = "Hyprland";
    #XDG_SESSION_DESKTOP = "Hyprland";
    #XDG_SESSION_TYPE = "wayland";
    #GDK_BACKEND = "wayland";
    #GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    #QT_QPA_PLATFORM = "wayland";
    #MOZ_ENABLE_WAYLAND = "1";
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
   jack.enable = true;
  };
  # hardware.pulseaudio.enable = true;

  # Swaylock won't accept correct password if this line is removed
  security.pam.services.swaylock = {};

  # Enable Polkit
  security.polkit.enable = true;

  # Allow Unfree Softwares
  nixpkgs.config.allowUnfree = true;  
  # Nix Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nazakat = {
    isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    alarm-clock-applet
    android-studio
    android-tools
    audacity
    bat
    blueman
    bluez
    bluez-tools
    brightnessctl
    btop
    celluloid
    clang
    clang-tools
    cliphist
    cmake
    discord
    distrobox
    dive # look into docker image layers
    docker-compose # start group of containers for dev
    dunst
    feh
    fish
    flameshot
    (pkgs.callPackage ../pkgs/free-download-manager.nix {})
    gcc
    gdb
    gh
    gimp
    git
    github-desktop
    google-chrome
    grimblast # A helper for screenshots within Hyprland, based on grimshot
    grim # Grab images from a Wayland compositor
    gsettings-desktop-schemas
    handbrake
    hugo
    hyprpaper
    imagemagick
    inkscape
    jdk
    kazam
    killall
    lf
    libinput-gestures
    libnotify
    libreoffice-fresh
    libsForQt5.kdeconnect-kde
    # libsForQt5.kdenlive
    libsForQt5.kget
    libsForQt5.okular
    libsForQt5.polkit-kde-agent
    libsForQt5.qt5ct
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtwayland
    libvirt
    lldb_17
    # lutris
    # lua-language-server
    luajit
    # lvim
    mako
    mangohud
    neofetch
    nerdfonts
    networkmanagerapplet
    nomacs
    nwg-look
    obs-studio
    onlyoffice-bin_latest
    openboard
    papirus-icon-theme
    partition-manager
    pavucontrol
    pipewire
    podman-tui # status of containers in the terminal
    #podman-compose # start group of containers for dev
    polkit
    python3
    # python311Packages.streamlit
    qalculate-qt
    qemu
    qt6.full
    qt6Packages.qtstyleplugin-kvantum
    qt6.qtwayland
    ranger
    remmina
    #rnix-lsp  package removed in latest branch
    rPackages.settings
    sddm
    slurp
    streamlit
    swappy
    swaylock-effects
    swww
    sxhkd
    #teamviewer
    telegram-desktop
    tldr
    tree
    unzip
    ventoy-full
    vim
    vimPlugins.clangd_extensions-nvim
    vimPlugins.coc-pyright
    vimPlugins.nvim-dap
    vimPlugins.nvim-dap-ui
    # vimPlugins.null-ls-nvim
    virt-manager
    # virtualbox
    vlc
    # vmware-workstation
    vscode
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        ms-vscode.cpptools-extension-pack
        formulahendry.code-runner
      ];
    })
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
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "nix-2.15.3"
  ];
  
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerdfonts
    fira-code
    # font-awesome
    # google-fonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  #services.teamviewer.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.nix-ld.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
