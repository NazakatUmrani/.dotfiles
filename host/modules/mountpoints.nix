{ config, lib, ... }:

with lib;

{
  options.my.mounts.ntfs = {
    enable = mkEnableOption "NTFS mounts for Windows partitions" // {
      default = true;
    };
  };

  config = mkIf config.my.mounts.ntfs.enable {
    fileSystems."/home/nazakat/WindowsData" = {
      device = "/dev/disk/by-uuid/E2CE55C2CE559021";
      fsType = "ntfs";
      options = [ "rw" "uid=nazakat" "gid=users" ];
    };

    fileSystems."/home/nazakat/Nazakat Umrani" = {
      device = "/dev/disk/by-uuid/688E1D518E1D1960";
      fsType = "ntfs";
      options = [ "rw" "uid=nazakat" "gid=users" ];
    };
  };
}
