{ pkgs, system, ... }:

let
  python = pkgs.python3;

  pythonApp = pkgs.stdenv.mkDerivation {
    pname = "my-python-app";
    version = "1.0";
    src = ../../src;

    installPhase = ''
      mkdir -p $out/app
      cp hello.py $out/app/
    '';
  };

  rootImage = pkgs.buildEnv {
    name = "my-docker-root";
    paths = [ python pythonApp ];
    pathsToLink = [ "/bin" "/app" ];  # python will be linked in /bin
  };
in
pkgs.dockerTools.buildImage {
  name = "my-python-hello";
  tag = "latest";

  fromImage = pkgs.dockerTools.pullImage {
    imageName = "python";
    finalImageTag = "3.11-slim";
    imageDigest = "sha256:7029b00486ac40bed03e36775b864d3f3d39dcbdf19cd45e6a52d541e6c178f0";
    sha256 = "sha256-lUrhG5Omgdk81NmQwQTo4wnEfq2+r2nGePpgTSYgVU0=";
  };

  copyToRoot = rootImage;

  config = {
    WorkingDir = "/app";
    Cmd = [ "python" "/app/hello.py" ];  # will now work since python is in /bin
  };
}
