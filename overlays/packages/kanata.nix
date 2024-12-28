{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "myKanata";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/jtroo/kanata/releases/download/v1.7.0/kanata_macos_arm64";
    hash = "sha256-y3ZD9ygB8SSTVpL9e2MqDfkEocB+J/EYhgUEiGLr3SM=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/kanata
    chmod +x $out/bin/kanata
  '';
}
