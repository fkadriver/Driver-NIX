{
  description = "Driver-NIX: modular NixOS flake with Home Manager, Hyprland, and tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }:
  let
    system = "x86_64-linux";
    # keep a local pkgs if you need to import it, or use nixpkgs directly below
    # pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.latitude-nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      # ensure Home Manager NixOS module is loaded and make flake inputs available
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/latitude-nixos/configuration.nix
      ];

      specialArgs = { inherit inputs; };

      # ...existing code...
    };
  };
}
