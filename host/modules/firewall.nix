{ config, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 5000 3000 5173 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 5173; to = 5174; }
      { from = 8000; to = 8010; }
    ];
  };
}
