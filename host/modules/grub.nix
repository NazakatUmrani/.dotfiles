{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    enable = true;
    extraInstallCommands =  ''
${pkgs.coreutils}/bin/cat << EOF >> /boot/grub/grub.cfg

# Shutdown
menuentry "Shutdown" --class shutdown {
  halt
}

# Reboot
menuentry "Reboot" --class restart{
  reboot
}
EOF
   '';
   # Set the theme for grub using the link of the theme
    theme = "${import ../../pkgs/grub-theme.nix { inherit pkgs; }}";
  };
}
