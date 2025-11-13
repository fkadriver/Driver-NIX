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

  networking.hostName = "laptop";

  users.users = lib.mkForce (config.users.users or {}) // {
    # create the user from hosts/laptop/user.nix
    ${user.username} = {
      isNormalUser = true;
      uid = user.uid;
      extraGroups = user.groups;
      description = "User: ${user.fullName}";
      home = "/home/${user.username}";
      shell = pkgs.zsh;
    };
  };

  # Wire home-manager for that username to a file in /home/ (see optional home files below)
  # If you prefer to keep home configs inside repo, import them here, e.g.:
  # home-manager.users.${user.username} = import ../../home/${user.username}.nix { inherit pkgs; };
  # For now we set a minimal example:
  programs.home-manager.enable = true;
  home-manager.users.${user.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    programs.zsh.enable = true;
    home.packages = with pkgs; [ git neovim ];
  };
}
