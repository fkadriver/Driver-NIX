{
  description = "Driver-NIX: modular NixOS flake with Home Manager, Hyprland, and tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ ... }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.latitude-nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      # make sure the home-manager NixOS module is loaded before your host config
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./hosts/latitude-nixos/configuration.nix
      ];

      # expose flake inputs to NixOS modules (so user.nix can reference `inputs`)
      specialArgs = { inherit inputs; };

      # ...existing code...
    };
  };
}
