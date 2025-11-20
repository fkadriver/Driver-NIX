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
        latitude-nixos = import ./nixosConfigurations/latitude-nixos.nix flakeContext;
        nixos = import ./nixosConfigurations/nixos.nix flakeContext;
      };
    };
}
