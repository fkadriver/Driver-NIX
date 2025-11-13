{ config, pkgs, lib, ... }:

{
  environment.systemPackages = lib.mkForce (config.environment.systemPackages or []) ++ with pkgs; [
    htop
    git
    tmux
  ];
}
