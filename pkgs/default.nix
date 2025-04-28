final: prev: {
  cljstyle = final.callPackage ./cljstyle.nix {};
  defaultbrowser = final.callPackage ./defaultbrowser.nix {};
  desktoppr = final.callPackage ./desktoppr.nix {};
  kanata = final.callPackage ./kanata.nix {};
  karabiner-driverkit = final.callPackage ./karabiner-driverkit.nix {};
}
