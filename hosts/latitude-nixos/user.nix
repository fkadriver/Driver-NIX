{ pkgs, ... }:

{
  # Basic Home Manager user module — keep minimal for stability.
  # NixOS already declares the system user; don't set home.username or home.fullName here.
  home.stateVersion = "24.11"; # match your Home Manager / nixpkgs release
  home.packages = [ ];

  # Hyprland/Home‑Manager integration removed for stability.
  # Re-add imports/programs.hyprland once the hyprland HM module is provided and imported.
}
