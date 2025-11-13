# Blueprint layout (informational)

This directory documents the intended "blueprint" layout. It's intentionally lightweight.

Layout summary:
- `modules/` — NixOS modules that are reusable across hosts.
- `hosts/` — host-specific top-level `configuration.nix` files.
- `hosts/common/` — shared user/home-manager configuration.
- `secrets/` — local secrets (ignored by git).

Use `numtide/blueprint` as an inspiration or generator, but this repo doesn't require the blueprint tool to build.
