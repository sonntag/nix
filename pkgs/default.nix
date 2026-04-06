final: prev: {
  # cljstyle = final.callPackage ./cljstyle.nix {};
  codebase-memory-mcp = final.callPackage ./codebase-memory-mcp.nix {};
  defaultbrowser = final.callPackage ./defaultbrowser.nix {};
  desktoppr = final.callPackage ./desktoppr.nix {};
  # karabiner-driverkit = final.callPackage ./karabiner-driverkit.nix {};
  mdts = final.callPackage ./mdts.nix {};
  sidecar = final.callPackage ./sidecar.nix {};
  slack-mcp-server = final.callPackage ./slack-mcp-server.nix {};
  td = final.callPackage ./td.nix {};
}
