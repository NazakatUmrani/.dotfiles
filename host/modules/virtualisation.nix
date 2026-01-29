{ config, pkgs, ... }:

{
  virtualisation = {
    waydroid.enable = true;  #Virtulaization for waydroid
    # docker = {
    #   enable = true; #virtualisation for docker
    #   rootless = {
    #     enable = true;
    #     setSocketVariable = true;
    #   };
    # };
    libvirtd.enable = true;
    # Enable common container config files in /etc/containers
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true; #`docker` alias for podman
      defaultNetwork.settings.dns_enabled = true; # for containers under podman-compose.
    };
  };
  environment.systemPackages = with pkgs; [
    distrobox # install images that are toolboxes
    dive # look into docker image layers
    docker-compose # start group of containers for dev
    libvirt
    podman-tui # status of containers in the terminal
    podman-compose # start group of containers for dev
    qemu
    virt-manager
    # vmware-workstation
    wine
  ];
}
