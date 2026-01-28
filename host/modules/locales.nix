{ config, ... }:
let
  locale = "en_US.UTF-8";
in
{
  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #  useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
    # Configure keymap in X11
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      #videoDrivers = [ "intel" ];
    };
  };
}
