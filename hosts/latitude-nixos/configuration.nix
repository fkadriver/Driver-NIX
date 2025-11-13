{ config, pkgs, lib, home-manager, hyprland, ... }:

let
  # Load local-only overrides (e.g., Tailscale keys)
  local = import ./local.nix;
in
{
  ####################################################################
  # MODULE IMPORTS
  ####################################################################
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

  ####################################################################
  # HOSTNAME
  ####################################################################
  networking.hostName = "latitude-nixos";

  ####################################################################
  # USER SETUP
  ####################################################################
  users.users.${user.username} = {
    isNormalUser = true;
    extraGroups = user.groups;
    description = user.fullName;
    shell = pkgs.zsh;
  };

  ####################################################################
  # HOME MANAGER
  ####################################################################
  programs.home-manager.enable = true;
  home-manager.users.${user.username} = import ../../home/common.nix;

  ####################################################################
  # DISPLAY MANAGER & WAYLAND
  ####################################################################
  services.xserver.enable = true;

  # Use GDM with Wayland
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Enable Hyprland as the session
  programs.hyprland.enable = true;

  # Set environment variables for Wayland session
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  ####################################################################
  # WAYBAR MULTI-MONITOR TASKBAR
  ####################################################################
  services.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    output = [ "*" ]; # Show on all monitors
  };

  ####################################################################
  # SOUND, BLUETOOTH, AND PIPEWIRE
  ####################################################################
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  ####################################################################
  # HARDWARE ACCELERATION
  ####################################################################
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  ####################################################################
  # NETWORK
  ####################################################################
  networking.networkmanager.enable = true;

  # Example: Tailscale configuration loaded from local.nix
  # local.nix should be .gitignored
  networking.tailscale.enable = local.tailscaleEnable or false;
  networking.tailscale.authKeyFile = local.tailscaleAuthKeyFile;
}
