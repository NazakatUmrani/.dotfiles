{ config, pkgs, ... }:

{
  # Enable sound.
  # sound.enable = true; No effect in lastest version
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [];
    };
  };
  # hardware.pulseaudio.enable = true;
}
