{
  # Informational module: lists canonical locations for this repository.
  name = "Driver-NIX blueprint layout";
  hosts = [ "hosts/latitude-nixos/configuration.nix" "hosts/nas-nixos/configuration.nix" ];
  modules = [ "modules/common/packages.nix" "modules/desktop/wayland.nix" ];
  common = "hosts/common/user.nix";
}
