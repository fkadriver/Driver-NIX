{ config, pkgs, lib, ... }:

let
  username = "scott";
in
{
  imports = [
    ../../modules/common/packages.nix
  ];

  networking.hostName = "nas-nixos";
  system.stateVersion = "24.05";

  users.users = {
    "${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      description = "Shared user";
      shell = pkgs.zsh;
      # hashedPassword left to secrets/...
    };
  };

  # Headless server: no display manager
  services.xserver.enable = false;

  environment.systemPackages = with pkgs; [
    git
    samba
    tailscale
    syncthing
  ];

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.syncthing.enable = true;

  home-manager.users = {
    "${username}" = import ../common/user.nix { inherit pkgs; };
  };
}
