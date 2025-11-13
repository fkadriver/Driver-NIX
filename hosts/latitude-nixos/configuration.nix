{ config, pkgs, lib, homeManager, ... }:

let
  username = "scott";
in
{
  imports = [
    ../../modules/common/packages.nix
    ../../modules/desktop/wayland.nix
    # Home Manager NixOS module (provided via flake specialArgs)
    homeManager.nixosModules.home-manager
  ];

  networking.hostName = "latitude-nixos";

  system.stateVersion = "22.11";

  users.users = {
    "${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
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

  # Enable the system-level wayland helpers
  driverNix.wayland.enable = true;

  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    vscode
    chromium
    firefox
    # tailscale
    # syncthing
  ];

  # services.tailscale.enable = true;
  # services.syncthing.enable = true;
  # services.openssh.enable = true;

  networking.networkmanager.enable = true;
}
