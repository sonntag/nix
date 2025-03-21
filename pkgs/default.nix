final: prev: {
  cljstyle = final.callPackage ./cljstyle.nix {};
  desktoppr = final.callPackage ./desktoppr.nix {};
  kanata = final.callPackage ./kanata.nix {};
  kanata-daemon-shim = final.callPackage ./kanata-daemon-shim {};
  karabiner-driverkit = final.callPackage ./karabiner-driverkit.nix {};
}
