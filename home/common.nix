{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
  ];

  home.stateVersion = "24.11";

  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    userName = "Driver User";
    userEmail = "driver@example.com";
  };

  home.packages = with pkgs; [
    neovim
    htop
    zoxide
  ];

  services.syncthing.enable = true;
}
