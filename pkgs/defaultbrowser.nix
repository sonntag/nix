{
  lib,
  stdenv,
  fetchurl,
}: let
  pname = "defaultbrowser";
  version = "1.1";
  hash = "sha256-HfZg3E8cMz9RJR8uVe1JIX+YILEQ0WBvvyy5axv6bKY=";
  meta = with lib; {
    description = "Command line tool for getting and setting a default browser (HTTP handler) in macOS";
    homepage = "https://github.com/kerma/defaultbrowser";
    license = licenses.mit;
    platforms = ["aarch64-darwin"];
  };
in
  stdenv.mkDerivation rec {
    inherit pname version meta;
    src = fetchurl {
      url = "https://github.com/kerma/defaultbrowser/releases/download/${version}/defaultbrowser";
      inherit hash;
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/$pname
      chmod +x $out/bin/$pname
    '';
  }
