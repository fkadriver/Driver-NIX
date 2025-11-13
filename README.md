Driver-NIX — modular NixOS flake + Home Manager

How to use:
  sudo nixos-rebuild switch --flake .#laptop
  sudo nixos-rebuild switch --flake .#desktop

Add new hosts by creating directories under hosts/ and adding them to flake.nix.
Each host must include:
  - configuration.nix
  - user.nix (exports { username, fullName, uid, groups })

