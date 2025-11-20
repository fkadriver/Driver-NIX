{
  description = "NixOS with Bitwarden secrets + interactive master password prompt";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.yourhost = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            environment.systemPackages = [
              nixpkgs.pkgs.bitwarden-cli
              nixpkgs.pkgs.jq
            ];

            # Enable ssh-agent for user services
            programs.ssh.startAgent = true;

            # ============================================
            # SYSTEMD USER SERVICE: Bitwarden Login + Key Loader
            # ============================================
            systemd.user.services."bitwarden-login" = {
              description = "Prompt for Bitwarden master password, login, and sync";
              wantedBy = [ "default.target" ];

              serviceConfig = {
                Type = "simple";

                ExecStart = nixpkgs.pkgs.writeShellScript "bw-login" ''
                  set -euo pipefail

                  # Ask for master password
                  MASTER_PW=$(systemd-ask-password "Enter Bitwarden master password:")

                  echo "Logging into Bitwarden..."
                  export BW_SESSION=$(echo "$MASTER_PW" | bw login --raw)

                  echo "Syncing vault..."
                  bw sync --session "$BW_SESSION"

                  # Store session in runtime (tmpfs), not disk
                  mkdir -p "$XDG_RUNTIME_DIR/bw"
                  chmod 700 "$XDG_RUNTIME_DIR/bw"
                  printf "%s" "$BW_SESSION" > "$XDG_RUNTIME_DIR/bw/session"
                  chmod 600 "$XDG_RUNTIME_DIR/bw/session"
                '';
              };
            };


            # ============================================
            # SYSTEMD USER SERVICE: Load SSH key from BW
            # ============================================
            systemd.user.services."ssh-key-from-bitwarden" = {
              description = "Load SSH private key from Bitwarden into ssh-agent";
              after = [ "bitwarden-login.service" ];
              wants = [ "bitwarden-login.service" ];
              wantedBy = [ "default.target" ];

              serviceConfig = {
                Type = "oneshot";

                ExecStart = nixpkgs.pkgs.writeShellScript "bw-ssh-load" ''
                  set -euo pipefail

                  BW_SESSION=$(cat "$XDG_RUNTIME_DIR/bw/session")

                  # Replace with your item ID in Bitwarden:
                  SSH_ITEM_ID="REPLACE_WITH_SSH_KEY_ITEM_ID"

                  echo "Fetching SSH key from Bitwarden..."
                  KEY="$(bw get item "$SSH_ITEM_ID" --session "$BW_SESSION" | jq -r .notes)"

                  if [ -z "$KEY" ]; then
                    echo "No key found in Bitwarden item $SSH_ITEM_ID"
                    exit 1
                  fi

                  echo "$KEY" | ssh-add -
                '';
              };
            };


            # ============================================
            # Tailscale auth key loader from Bitwarden
            # ============================================
            systemd.user.services."tailscale-authkey-from-bitwarden" = {
              description = "Fetch Tailscale AuthKey from Bitwarden and apply";
              after = [ "bitwarden-login.service" ];
              wants = [ "bitwarden-login.service" ];
              wantedBy = [ "default.target" ];

              serviceConfig = {
                Type = "oneshot";

                ExecStart = nixpkgs.pkgs.writeShellScript "bw-ts-load" ''
                  set -euo pipefail

                  BW_SESSION=$(cat "$XDG_RUNTIME_DIR/bw/session")

                  # Replace with your Tailscale auth key item ID
                  TS_KEY_ID="REPLACE_WITH_TS_AUTHKEY_ITEM_ID"

                  AUTHKEY=$(bw get item "$TS_KEY_ID" --session "$BW_SESSION" | jq -r .notes)

                  if [ -z "$AUTHKEY" ]; then
                    echo "No Tailscale authkey found in BW item!"
                    exit 1
                  fi

                  # Apply the key
                  sudo tailscale up --authkey "$AUTHKEY"
                '';
              };
            };
          }
        ];
      };
    };
}

