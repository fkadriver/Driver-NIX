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

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = groups;
    description = fullName;
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = import ./user.nix { inherit pkgs inputs; };

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
