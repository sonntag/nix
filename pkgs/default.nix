final: prev: {
  # cljstyle = final.callPackage ./cljstyle.nix {};
  defaultbrowser = final.callPackage ./defaultbrowser.nix {};
  desktoppr = final.callPackage ./desktoppr.nix {};
  # karabiner-driverkit = final.callPackage ./karabiner-driverkit.nix {};
  mdts = final.callPackage ./mdts.nix {};
  slack-mcp-server = final.callPackage ./slack-mcp-server.nix {};
}
