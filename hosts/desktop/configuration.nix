{ config, pkgs, lib, ... }:

let
  user = import ./user.nix;
in
{
  imports = [
    ../..//modules/common/system.nix
    ../..//modules/common/networking.nix
    ../..//modules/common/packages.nix
    ../..//modules/common/home-manager.nix
    ../..//modules/desktop/hyprland.nix
  ];

  networking.hostName = "desktop";

  users.users = lib.mkForce (config.users.users or {}) // {
    ${user.username} = {
      isNormalUser = true;
      uid = user.uid;
      extraGroups = user.groups;
      description = "User: ${user.fullName}";
      home = "/home/${user.username}";
      shell = pkgs.zsh;
    };
  };

  programs.home-manager.enable = true;
  home-manager.users.${user.username} = { pkgs, ... }: {
    home.stateVersion = "23.11";
    programs.zsh.enable = true;
    home.packages = with pkgs; [ git tmux ];
  };
}
