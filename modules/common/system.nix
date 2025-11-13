{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "UTC";

  # Basic services
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
  ];
}
