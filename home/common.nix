{ config, pkgs, lib, ... }:

{
  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.home-manager.enable = true;

  # Example packages
  home.packages = with pkgs; [
    vim
    htop
    neovim
  ];

  # Hyprland related
  programs.hyprland.enable = true;
}
