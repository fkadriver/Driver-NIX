{ pkgs }:
pkgs.mkShell {
  # Add build dependencies
  packages = [
    pkgs.python3
    pkgs.python3Packages.numpy
  ];

  # Add environment variables
  env = { };

  # Load custom bash code
  shellHook = ''
    export PS1="(python numpy) $PS1"
  '';
}