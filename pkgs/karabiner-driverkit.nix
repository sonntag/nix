{
  lib,
  stdenv,
  fetchurl,
  cpio,
  xar,
}: let
  pname = "karabiner-driverkit";
  version = "5.0.0";
  hash = "sha256-hKi2gmIdtjl/ZaS7RPpkpSjb+7eT0259sbUUbrn5mMc=";
  meta = with lib; {
    description = "This project implements a virtual keyboard and virtual mouse using DriverKit on macOS.";
    homepage = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice";
    downloadPage = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.publicDomain;
    platforms = ["aarch64-darwin"];
  };
in
  stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${version}/Karabiner-DriverKit-VirtualHIDDevice-${version}.pkg";
      inherit hash;
    };

    nativeBuildInputs = [
      cpio
      xar
    ];

    unpackPhase = ''
      xar -xf $src
      zcat Payload | cpio -i
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R Applications/.Karabiner-VirtualHIDDevice-Manager.app $out
      cp -R Library/Application\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app $out
      runHook postInstall
    '';
  }
