{ config, pkgs, lib, home-manager, hyprland, ... }:

let
  user = import ./user.nix;
  local = import ./local.nix;
in
{
  imports = [
    ../../modules/common/system.nix
    ../../modules/common/networking.nix
    ../../modules/common/packages.nix
    ../../modules/common/services.nix
    ../../modules/common/home-manager.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/wayland.nix
  ];

  # Hostname
  networking.hostName = "latitude-nixos";

  # User setup
  users.users.${user.username} = {
    isNormalUser = true;
    extraGroups = user.groups;
    description = user.fullName;
    shell = pkgs.zsh;
  };

  # Home Manager setup
  programs.home-manager.enable = true;
  home-manager.users.${user.username} = import ../../home/common.nix;

  # Local-only settings (ignored by Git)
  imports = [ ./local.nix ];

  # ---- GDM + Hyprland Wayland Setup ----
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Enable Hyprland session
  programs.hyprland.enable = true;

  # Wayland environment variables
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Waybar multi-monitor setup (taskbar on all displays)
  services.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    output = [ "*" ]; # show on all screens
  };

  # Enable sound, bluetooth, etc.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.blueman.enable = true;

  # Enable hardware acceleration
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable NetworkManager
  networking.networkmanager.enable = true;
}
