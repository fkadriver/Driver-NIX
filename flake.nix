{
  description = "Driver's flakes";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
  };
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      nixosConfigurations = {
        latitude-nixos = import ./hosts/latitude-nixos/system.nix flakeContext;
        latitude-base = import ./hosts/latitude-nixos/configuration.nix flakeContext;
      };
      nixosModules = {
        bitwarden = import ./modules/bitwarden.nix flakeContext;
        tailscale = import ./nixosModules/tailscale.nix flakeContext;
      };
  };
}
