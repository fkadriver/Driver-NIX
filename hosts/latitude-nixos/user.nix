{
  username = "scott";
  fullName = "Scott Jensen";
  uid = 1000;
  groups = [ "wheel" "networkmanager" "video" ];

  # `inputs` is available because flake.nix sets specialArgs = { inherit inputs; }
  hyprImports = if builtins.hasAttr "hyprland" inputs then [ inputs.hyprland.homeManagerModules.hyprland ] else [];
  imports = hyprImports;

  # move hyprland settings here
  programs.hyprland = {
    enable = true;
    # add user-specific hyprland options here
  };
}
