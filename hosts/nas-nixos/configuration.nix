{ config, pkgs, lib, homeManager, ... }:

let
  username = "scott";
in
{
  imports = [
    ../../modules/common/packages.nix
    # Home Manager NixOS module (provided via flake specialArgs)
    homeManager.nixosModules.home-manager
  ];

  networking.hostName = "nas-nixos";
  system.stateVersion = "24.05";

  users.users = {
    "${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
    };
  };

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      {
        disabledModules = [ "services/mako.nix" ];
      }
    ];
    users = {
      "${username}" = import ../common/user.nix { inherit pkgs; };
    };
  };

  # Headless server: no X server, no display manager
  services.xserver.enable = false;

  environment.systemPackages = with pkgs; [
    samba
    tailscale
    syncthing
  ];

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.syncthing.enable = true;
}
