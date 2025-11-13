{ config, pkgs, lib, hyprland, ... }:

{
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    wl-clipboard
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
  ];

  # Wayland environment variables
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  home-manager.users.scott = {
    home.packages = [
      pkgs.waybar
      pkgs.wl-clipboard
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xwayland
    ];

    programs.waybar.enable = true;
    programs.hyprland.enable = true;

    # Set the appropriate environment variables for Wayland
    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
  };
}
