{
  lib,
  stdenv,
  fetchzip,
}: let
  pname = "cljstyle";
  version = "0.16.626";
  archMap = {
    "x86_64-linux" = "linux_amd64_static";
    "x86_64-darwin" = "macos_amd64";
    "aarch64-darwin" = "macos_arm64";
  };
  hashes = {
    "x86_64-linux" = "sha256-DGg2MWUVyFdigZE8PutPqjHHYvT5zSrmGIsUwZiS000=";
    "x86_64-darwin" = "sha256-IfehvZgVWo8pqWFaPaMFrT1XjeWPCyd4N+0WXBLwL4w=";
    "aarch64-darwin" = "sha256-jKHMkJ8kfy83H0uhu7peFf37d+njk3VSYat5kk+PD5w=";
  };
  meta = with lib; {
    description = "A tool for formatting Clojure code";
    homepage = "https://github.com/greglook/cljstyle";
    license = licenses.epl10;
    platforms = builtins.attrNames archMap;
  };
  getBinary = system: let
    arch = archMap.${system} or (throw "Unsupported system: ${system}");
    hash = hashes.${system};
  in
    fetchzip {
      url = "http://github.com/greglook/cljstyle/releases/download/${version}/cljstyle_${version}_${arch}.zip";
      inherit hash;
    };
in
  stdenv.mkDerivation {
    inherit pname version meta;
    src = getBinary stdenv.hostPlatform.system;

    installPhase = ''
      mkdir -p $out/bin
      cp $src/$pname $out/bin/$pname
      chmod +x $out/bin/$pname
    '';
  }
