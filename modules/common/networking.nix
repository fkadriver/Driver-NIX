{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.hostName = "unset-hostname";
}
