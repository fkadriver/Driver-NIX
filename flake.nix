{
  description = "Driver-NIX: modular NixOS flake with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # pick your preferred release
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    # optional: add other inputs here (e.g. flakes for hyprland)
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    systems = [ "x86_64-linux" ];
    pkgsFor = system: import nixpkgs { inherit system; };
  in
  {
    # Enumerate host configurations here. Add more entries for each host.
    nixosConfigurations = {
      laptop = pkgsFor "x86_64-linux".lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/laptop/configuration.nix ];
        specialArgs = { inherit self; };
      };

      desktop = pkgsFor "x86_64-linux".lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/desktop/configuration.nix ];
        specialArgs = { inherit self; };
      };
    };

    # Expose a small helper to show available flakes (optional)
    devShells = {
      x86_64-linux.default = pkgsFor "x86_64-linux".mkShell {
        buildInputs = [ pkgsFor "x86_64-linux".git ];
      };
    };
  };
}