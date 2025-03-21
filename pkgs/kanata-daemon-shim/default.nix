{
  karabiner-driverkit,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "kanata-daemon-shim";
  version = "0.1.0";
  src = ./.;
  patchPhase = ''
    substituteInPlace main.c \
      --subst-var-by client "${karabiner-driverkit}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-DriverKit-VirtualHIDDeviceClient.app/Contents/MacOS/Karabiner-DriverKit-VirtualHIDDeviceClient"
  '';
  buildPhase = ''
    cc main.c -o kanata-daemon-shim
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp kanata-daemon-shim $out/bin
  '';
}
