{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "myKanata";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/jtroo/kanata/releases/download/v1.8.0/kanata_macos_arm64";
    hash = "sha256-oHIpb1Hvi3gJUYnYJWXGs1QPoHerdWCA1+bHjG4QAQ4=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/kanata
    chmod +x $out/bin/kanata
  '';
}
