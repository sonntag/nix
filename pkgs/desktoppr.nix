{
  lib,
  stdenv,
  fetchzip,
}: let
  pname = "desktoppr";
  version = "0.5";
  hash = "sha256-JHnQS4ZL0GC4shBcsKtmPOSFBY6zLSV/IAFRb4+A++Q=";
  meta = with lib; {
    description = "Simple command line tool to set the desktop picture on macOS";
    homepage = "https://github.com/scriptingosx/desktoppr";
    license = licenses.asl20;
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
