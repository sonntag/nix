{
  stdenv,
  fetchurl,
}: let
  version = "1.8.0";
  archMap = {
    "aarch64-darwin" = "macos_arm64";
  };
  getBinary = system: let
    arch = archMap.${system} or (throw "Unsupported system: ${system}");
  in
    fetchurl {
      url = "https://github.com/jtroo/kanata/releases/download/v${version}/kanata_${arch}";
      hash = "sha256-oHIpb1Hvi3gJUYnYJWXGs1QPoHerdWCA1+bHjG4QAQ4=";
    };
in
  stdenv.mkDerivation rec {
    pname = "kanata";
    inherit version;
    src = getBinary stdenv.hostPlatform.system;

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/kanata
      chmod +x $out/bin/kanata
    '';
  }
