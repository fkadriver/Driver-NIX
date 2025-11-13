{
  description = "Driver-NIX - flake (blueprint-friendly, modular NixOS + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blueprint.url = "github:numtide/blueprint";
  };

  outputs = inputs@{ self, nixpkgs, blueprint, ... }:
    let
      # read the hyphenated input from inputs
      homeManager = inputs."home-manager";

      # target system
      system = "x86_64-linux";

      # import a pkgs for the target system
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # NixOS configurations for two hosts
      nixosConfigurations = {
        latitude-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/latitude-nixos/configuration.nix
          ];
          # pass useful inputs into modules
          specialArgs = { inherit self homeManager nixpkgs inputs; };
        };

        nas-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nas-nixos/configuration.nix
          ];
          specialArgs = { inherit self homeManager nixpkgs inputs; };
        };
      };

      # simple devShell
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [ pkgs.git ];
      };
    };
}
