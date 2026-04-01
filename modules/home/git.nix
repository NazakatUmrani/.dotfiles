{ config, ... }:

{
  programs = {
    git = {
      enable = true;
      signing.format = null;
      settings = {
        user = {
          name = "Nazakat Umrani - NixOS Linux";
          email = "unazakat70@gmail.com";
        };
        init.defaultBranch = "main";
        http.version = "HTTP/1.1"; # solves some curl fail EOF, issues
        safe.directory = "/home/nazakat/WindowsData/Projects/SmartFix-AI-Driven-Technician-Booking-Platform";
      };
    };
  };
}
