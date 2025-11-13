{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    codium
    firefox
    slack
    syncthing
    tailscale
  ];
}
