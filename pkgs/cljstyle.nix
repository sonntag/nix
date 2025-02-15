{
  lib,
  stdenv,
  fetchzip,
}: let
  version = "0.16.626";
  archMap = {
    "x86_64-linux" = "linux_amd64_static";
    "x86_64-darwin" = "macos_amd64";
    "aarch64-darwin" = "macos_arm64";
  };
  getBinary = system: let
    arch = archMap.${system} or (throw "Unsupported system: ${system}");
  in
    fetchzip {
      url = "http://github.com/greglook/cljstyle/releases/download/${version}/cljstyle_${version}_${arch}.zip";
      sha256 =
        {
          "linux_amd64_static" = "sha256-DGg2MWUVyFdigZE8PutPqjHHYvT5zSrmGIsUwZiS000=";
          "macos_amd64" = "sha256-IfehvZgVWo8pqWFaPaMFrT1XjeWPCyd4N+0WXBLwL4w=";
          "macos_arm64" = "sha256-jKHMkJ8kfy83H0uhu7peFf37d+njk3VSYat5kk+PD5w=";
        }
        .${arch};
    };
in
  stdenv.mkDerivation rec {
    pname = "cljstyle";
    inherit version;
    src = getBinary stdenv.hostPlatform.system;

    installPhase = ''
      mkdir -p $out/bin
      cp $src/$pname $out/bin/$pname
      chmod +x $out/bin/$pname
    '';

    meta = with lib; {
      description = "A tool for formatting Clojure code";
      homepage = "https://github.com/greglook/cljstyle";
      license = licenses.epl10;
      platforms = builtins.attrNames archMap;
    };
  }
