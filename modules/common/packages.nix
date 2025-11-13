{ config, pkgs, lib, ... }:

{
  # Common packages for every host, kept minimal.
  environment.systemPackages = with pkgs; [
    git
  ];
}
