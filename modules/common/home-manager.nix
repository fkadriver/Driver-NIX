{ config, pkgs, lib, ... }:

let
  hm = import (builtins.fetchTarball {
    # We use the home-manager provided by the flake inputs at evaluation time,
    # so this file only needs to import the module when plugged into the flake.
    # When used from the flake (see flake.nix) the inputs.home-manager module
    # will be available via the flake evaluation.
    # (This file is minimal and intended to be included in each host config.)
    url = "";
  }) {};
in
{
  # The host's configuration will include the home-manager nixos module in
  # the host's flake evaluation. Keep this file minimal and let the flake
  # inputs provide the actual home-manager module.
  # Users will be created in the host configuration (see hosts/*/configuration.nix).
}
