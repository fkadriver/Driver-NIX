{ config, pkgs, lib, ... }:

{
  options = {
    driverNix.wayland.enable = lib.mkEnableOption "Enable minimal system-level Wayland helpers";
  };

  config = lib.mkIf (config.driverNix.wayland.enable or false) {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      xdg-desktop-portal
    ];
  };
}
