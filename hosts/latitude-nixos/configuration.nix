{ config, pkgs, lib, ... }:

let
  username = "scott";
  fullName = "Scott Jensen";
  groups = [ "wheel" "networkmanager" "audio" "video" ];
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/system.nix
    ../../modules/common/networking.nix
    ../../modules/common/packages.nix
    ../../modules/common/services.nix
    ../../modules/common/home-manager.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/wayland.nix
  ];

  networking.hostName = "latitude-nixos";

  # Ensure NixOS knows the system version for state migration checks
  system.stateVersion = "24.05"; # latest stable release (update if you target a newer one)

  # Explicit attribute sets avoid subtle interpolation/evaluation issues
  users.users = {
    "${username}" = {
      isNormalUser = true;
      extraGroups = groups;
      description = fullName;
      shell = pkgs.zsh;
    };
  };

  # Home-manager user entry as an explicit attrset
  home-manager.users = {
    "${username}" = import ./user.nix { inherit pkgs; };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.blueman.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  networking.networkmanager.enable = true;
}
