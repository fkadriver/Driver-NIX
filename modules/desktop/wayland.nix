{ config, pkgs, lib, hyprland, ... }:

{
  services.xserver.enable = false;
  services.xwayland.enable = true;

  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    wl-clipboard
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  # Optionally pull some HyprVibe-like defaults
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}
