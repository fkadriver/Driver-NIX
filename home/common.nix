{ pkgs, ... }:

{
  # add a home stateVersion for home-manager
  home.stateVersion = "23.11";

  programs.zsh.enable = true;
  programs.git.enable = true;

  # Example packages
  home.packages = with pkgs; [
    vim
    htop
    neovim
  ];

  # Hyprland related
  programs.hyprland.enable = true;
}
