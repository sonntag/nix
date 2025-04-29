final: prev: {
  cljstyle = final.callPackage ./cljstyle.nix {};
  defaultbrowser = final.callPackage ./defaultbrowser.nix {};
  desktoppr = final.callPackage ./desktoppr.nix {};
  dynamic-island-helper = final.callPackage ./dynamic-island-helper {};
  kanata = final.callPackage ./kanata.nix {};
  karabiner-driverkit = final.callPackage ./karabiner-driverkit.nix {};
  sbarlua = final.callPackage ./sbarlua.nix {};
  sketchyhelper = final.callPackage ./sketchyhelper {};
}
