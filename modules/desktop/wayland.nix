{ config, pkgs, lib, ... }:

{
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Provide a small, safe wayland helper module for system-level bits.
  # IMPORTANT: Do not set `home-manager.users.<user>.*` options from here.
  # Per-user Hyprland / Wayland programs belong in the user's home-manager
  # configuration (e.g. hosts/latitude-nixos/user.nix).
  options = {
    services.wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable minimal system-level Wayland helpers (does NOT configure per-user Hyprland).";
    };
  };

  config = lib.mkIf config.services.wayland {
    # System-level helpers only. Keep packages minimal; let users enable
    # Hyprland in their home-manager configuration if desired.
    environment.systemPackages = with pkgs; (config.environment.systemPackages or []) ++ [
      # Optionally add common Wayland utilities (user can remove/add in their own config)
      wl-clipboard
      wayland-utils
      pipewire
      # If you need xdg-portal support for Hyprland at the system level:
      xdg-desktop-portal
      # don't add hyprland here; prefer explicit per-user enablement in home-manager
    ];

    # Do NOT set home-manager.users.<user>.* here — it's the source of the error.
    # Example of correct place for Hyprland (in hosts/latitude-nixos/user.nix):
    #   programs.hyprland.enable = true;
    #   programs.hyprland.config = { ... };
  };
}
