{ config, pkgs, lib, ... }:

{
  options = {
    driverNix.wayland.enable = lib.mkEnableOption "Enable minimal system-level Wayland helpers (GDM on laptop)";
  };

  config = lib.mkIf (config.driverNix.wayland.enable or false) {
    services.gdm = {
      enable = true;
      # GDM uses Wayland by default on supported systems
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils
      xdg-desktop-portal
    ];
  };
}
