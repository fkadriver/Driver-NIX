{
  description = "Driver-NIX: modular NixOS flake with Home Manager, Hyprland, and tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.latitude-nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { 
        inherit self nixpkgs home-manager hyprland; 
      };
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/latitude-nixos/configuration.nix
      ];
    };
  };
}
