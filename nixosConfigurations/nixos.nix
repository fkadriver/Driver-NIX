{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    config = {
      environment = {
        systemPackages = [
          pkgs.sl
        ];
      };
      system = {
        stateVersion = "25.04";
      };
      users = {
        users = {
          nixos = {
            group = "users";
            isNormalUser = true;
            password = "nixos";
          };
        };
      };
    };
  };
in
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    nixosModule
  ];
  system = "x86_64-linux";
}
