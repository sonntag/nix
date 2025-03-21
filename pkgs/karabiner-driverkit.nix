{
  lib,
  stdenv,
  fetchurl,
}: let
  pname = "karabiner-driverkit";
  version = "5.0.0";
  hash = "";
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

    # unpack does not create a folder, so start from the current directory
    sourceRoot = ".";
    dontUnpack = true;
    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp $src $out/Karabiner-DriverKit-VirtualHIDDevice-${version}.pkg
      runHook postInstall
    '';
  }
