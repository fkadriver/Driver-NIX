{
  description = "flake for machine configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # To use a particular Home Manager release, use the url
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    # I'm not, because when I tried (with nixpkgs/nixos-23.11), there was a bug with systemd-boot
    #  that *wasn't* found during a `nixos-rebuild test`
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    # optional, not necessary for the module
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # NixOS hardware enablement
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Disko automatic disk partitioning
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    ersatztv-flake.url = "github:noblepayne/ersatztv-flake";
    ersatztv-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  # The @flakeInputBundle at the end collects all these inputs, and "packages" them into the flakeInputBundle variable
  outputs = { self, nixpkgs, home-manager, sops-nix, nixos-hardware, disko, ersatztv-flake, ...}@flakeInputBundle:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      MakeSystem = hostName:
        nixpkgs.lib.nixosSystem{
          specialArgs = {
            # Pass in all our inputs into the subsequent flakes
            inherit flakeInputBundle;
            # This one is after flakeInputBundle is created
            inherit hostName;
          };
          # Common modules here
          modules = [
            # Common configs
            ./configuration.nix

            # Telegraf module
            ./modules/telegraf
            
            #sops-nix
            sops-nix.nixosModules.sops
            
            # Host-specific configus
            ./hosts/${hostName}

            # This is the home-manager function with inputs to that function.
            # This is identical to `myfunc{a=100, b=15};`
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                flakeInputBundle.sops-nix.homeManagerModules.sops
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.adam = import ./home.nix;
            }
          ];
        };
      MakeDiskoSystem = hostName:
        nixpkgs.lib.nixosSystem{
          specialArgs = {
            # Pass in all our inputs into the subsequent flakes
            inherit flakeInputBundle;
            # This one is after flakeInputBundle is created
            inherit hostName;
          };
          # Common modules here
          modules = [
            disko.nixosModules.disko

            # Common configs
            ./configuration.nix

            # Telegraf module
            ./modules/telegraf
            
            #sops-nix
            sops-nix.nixosModules.sops
            
            # Host-specific configus
            ./hosts/${hostName}

            # This is the home-manager function with inputs to that function.
            # This is identical to `myfunc{a=100, b=15};`
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                flakeInputBundle.sops-nix.homeManagerModules.sops
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.adam = import ./home.nix;
            }
          ];
        };
    in {
    nixosConfigurations = {
      # Flake Name = MakeSystem <hostname>
      boomer-nixos = MakeSystem "boomer-nixos";
      framenix = MakeSystem "framenix";
      jackdaw-nixos = MakeSystem "jackdaw-nixos";
      immich-nixos = MakeDiskoSystem "immich-nixos";
      mealie-nixos = MakeDiskoSystem "mealie-nixos";
      revprox-nixos = MakeDiskoSystem "revprox-nixos";
      media-nixos = MakeSystem "media-nixos";
      podman-nixos = MakeDiskoSystem "podman-nixos";
      unifi-nixos = MakeDiskoSystem "unifi-nixos";
      graphite-nixos = MakeDiskoSystem "graphite-nixos";
      latitude-nixos = MakeSystem "latitude-nixos"
    };
    # Enables use of `nix develop` (which is apparently the new hotness) without using shell.nix!
    #    (Though, maybe there's a chicken-and-egg here: I can't use `nix` without my new shell, so I can't use `nix develop`
    #     to get my new shell...)
    # Either way, this is another example of another Flake output: a devShell
    devShell.x86_64-linux = 
      pkgs.mkShell {
        # Enable experimental features without having to specify the argument
        NIX_CONFIG = "experimental-features = nix-command flakes";
        buildInputs = [ pkgs.nix pkgs.home-manager pkgs.git ];
        shellHook = ''
          echo ""
          echo "Nix command and Flakes now available"
        '';
      };
  };
}
