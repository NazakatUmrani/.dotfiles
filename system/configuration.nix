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
   # theme = "/boot/grub/themes/Atmoic/theme.txt";
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
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = { 
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager = {
      sddm.enable = true;
      sddm.theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    };
  };
  # Nix Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #Virtulaization for waydroid
  virtualisation.waydroid.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Allow Unfree Softwares
  nixpkgs.config.allowUnfree = true;  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nazakat = {
    isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    alarm-clock-applet
    android-studio
    android-tools
    audacity
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
    dunst
    feh
    fish
    flameshot
    gcc
    gdb
    gh
    gimp
    git
    github-desktop
    google-chrome
    grimblast
    grimblast # A helper for screenshots within Hyprland, based on grimshot
    grim # Grab images from a Wayland compositor
    gsettings-desktop-schemas
    handbrake
    htop
    hugo
    hyprpaper
    imagemagick
    inkscape
    jdk
    # jetbrains.idea-ultimate
    kazam
    killall
    kitty
    lf
    libinput-gestures
    libnotify
    libreoffice-fresh
    libsForQt5.dolphin
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
    neovim
    nerdfonts
    networkmanagerapplet
    nomacs
    nwg-look
    obs-studio
    onlyoffice-bin_latest
    openboard
    papirus-icon-theme
    pipewire
    polkit
    qalculate-qt
    qemu
    qt6.full
    qt6Packages.qtstyleplugin-kvantum
    qt6.qtwayland
    ranger
    rnix-lsp
    rofi-wayland
    rPackages.settings
    sddm
    slurp
    swappy
    swaylock-effects
    swww
    sxhkd
    teamviewer
    telegram-desktop
    tldr
    tree
    unzip
    ventoy-full
    vim
    vimPlugins.clangd_extensions-nvim
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
        vscode-extensions.ms-vscode.cpptools
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "code-runner";
          publisher = "formulahendry";
          version = "0.12.1";
          sha256 = "0eb32ae3e8eea89fa29609aed95c13b5fde1221826bb0b3bb4cd17c2df94f61f";
        }
        {
          name = "cpptools-extension-pack";
          publisher = "ms-vscode";
          version = "1.3.0";
          sha256 = "ac7493ec26025629ecddfa970be158892e5781c8e68bb416ecce3216b511d385";
        }
      ];
    })
    waybar
    waydroid
    waypaper
    wget
    whatsapp-for-linux
    wine
    wireplumber
    wl-clipboard
    wlogout
    # wofi
    xdg-desktop-portal-hyprland
    xsettingsd
  ];

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerdfonts
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
  services.teamviewer.enable = true;

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
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
