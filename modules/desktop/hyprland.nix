{ config, pkgs, lib, ... }:

{
  # This file is a placeholder for desktop-specific modules (Hyprland, Wayland, fonts, etc.)
  # Add your Hyprland or WM/DE configuration here.
  environment.systemPackages = with pkgs; [
    xorg.xrandr # example - replace with real packages you'd like
  ];
}
