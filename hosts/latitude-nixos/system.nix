{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.self.nixosModules.bitwarden
    ];
    config = {
      system = {
        stateVersion = "25.04";
      };
      users = {
        users = {
          scott = {
            extraGroups = [
              "networkmanager"
              "wheel"
            ];
            initialHashedPassword = "$y$j9T$TqMt3I723budo6afJM6aG.$/1DVTm29z2pjnTKBt88gFakWufNa.WC0T0EmsfFKXz4";
            isNormalUser = true;
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
