{
  description = "Driver-NIX - flake (blueprint-friendly, modular NixOS + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    blueprint.url = "github:numtide/blueprint";
  };

  outputs = inputs@{ self, nixpkgs, "home-manager": homeManager, blueprint, ... }:
    let
      systems = [ "x86_64-linux" ];
      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      # NixOS configurations for two hosts
      nixosConfigurations = {
        latitude-nixos = pkgsFor "x86_64-linux".lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/latitude-nixos/configuration.nix
          ];
          # Provide inputs to modules (so they can reference inputs.home-manager etc.)
          specialArgs = { inherit self homeManager nixpkgs blueprint; };
        };

        nas-nixos = pkgsFor "x86_64-linux".lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nas-nixos/configuration.nix
          ];
          specialArgs = { inherit self homeManager nixpkgs blueprint; };
        };
      };

      # Expose a simple devShell for convenience (optional)
      devShells.x86_64-linux.default = pkgsFor "x86_64-linux".mkShell {
        buildInputs = [ pkgsFor "x86_64-linux".git ];
      };
    };
}
