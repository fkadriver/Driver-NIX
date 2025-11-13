# Driver-NIX

This repository holds modular NixOS + Home Manager configurations following the "blueprint" pattern.

Goals
- Use numtide/blueprint-inspired layout (modular, testable)
- Two hosts: `latitude-nixos` (laptop) and `nas-nixos` (server)
- Single shared `hosts/common/user.nix` for the user configuration
- Wayland/GDM is the default on the laptop
- Secrets (password hashes) stored out-of-repo; skeleton provided in `secrets/`

Quick commands
- Check flake: `nix flake check --show-trace`
- Build laptop: `sudo nixos-rebuild switch --flake .#latitude-nixos`
- Build server: `sudo nixos-rebuild switch --flake .#nas-nixos`

Password / secrets
- Do NOT commit real passwords. Use the skeleton at `secrets/hashed-passwords.nix`.
- Generate a hashed password:
  - `mkpasswd -m sha-512` (from whois/package `mkpasswd`) or
  - Use `python -c 'import crypt, getpass; print(crypt.crypt(getpass.getpass(), crypt.mksalt(crypt.METHOD_SHA512)))'`
- Put the resulting hash into `secrets/hashed-passwords.nix` and ensure it's in `.gitignore`.

Blueprint
- This repo provides a starting blueprint:
  - `modules/` — reusable NixOS modules (system-level)
  - `hosts/` — host-specific modules and imports
  - `hosts/common/` — shared per-host files (single `user.nix`)
  - `secrets/` — out-of-repo secrets (skeleton only)

Contributing
- Add modules under `modules/` and import them from host `configuration.nix`.
- Keep secrets out of git. Use `secrets/` locally and add to `.gitignore`.

