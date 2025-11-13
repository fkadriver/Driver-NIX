{ config, pkgs, lib, ... }:

{
  # Tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraUpFlags = [ "--ssh" ];
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "driver";
    dataDir = "/home/driver/Sync"; # or ~/Documents/Sync
    openDefaultPorts = true;
  };

  # Docker (optional, useful for dev)
  virtualisation.docker.enable = true;
}
