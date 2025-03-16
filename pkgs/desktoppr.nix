{
  lib,
  stdenv,
  fetchzip,
}: let
  pname = "desktoppr";
  version = "0.5";
  hash = "sha256-JHnQS4ZL0GC4shBcsKtmPOSFBY6zLSV/IAFRb4+A++Q=";
  meta = with lib; {
    description = "A tool for formatting Clojure code";
    homepage = "https://github.com/greglook/cljstyle";
    license = licenses.epl10;
    platforms = ["aarch64-darwin"];
  };
in
  stdenv.mkDerivation rec {
    inherit pname version meta;
    src = fetchzip {
      url = "https://github.com/scriptingosx/desktoppr/releases/download/v${version}/desktoppr-${version}-218.zip";
      inherit hash;
    };

    installPhase = ''
      mkdir -p $out/bin
      cp $src/$pname $out/bin/$pname
      chmod +x $out/bin/$pname
    '';
  }
