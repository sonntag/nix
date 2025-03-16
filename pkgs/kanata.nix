{
  lib,
  stdenv,
  fetchurl,
}: let
  pname = "kanata";
  version = "1.8.0";
  archMap = {
    "aarch64-darwin" = "macos_arm64";
  };
  hashes = {
    "aarch64-darwin" = "sha256-oHIpb1Hvi3gJUYnYJWXGs1QPoHerdWCA1+bHjG4QAQ4=";
  };
  meta = with lib; {
    description = "Improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    platforms = builtins.attrNames archMap;
  };
  getBinary = system: let
    arch = archMap.${system} or (throw "Unsupported system: ${system}");
    hash = hashes.${system};
  in
    fetchurl {
      url = "https://github.com/jtroo/kanata/releases/download/v${version}/kanata_${arch}";
      inherit hash;
    };
in
  stdenv.mkDerivation {
    inherit pname version meta;
    src = getBinary stdenv.hostPlatform.system;

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/$pname
      chmod +x $out/bin/$pname
    '';
  }
