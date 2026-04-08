{
  pkgs,
  lib,
  ...
}: {
  # sonntag.programs.nixvim.enable = true;
  darwin.wallpaper.image.path = ../../../backgrounds/rose-pine/rose_pine_shape.png;

  home.packages = with pkgs; [
    clojure
    uv
  ];

  home.sessionPath = ["$HOME/.local/bin"];

  # fli (flights) has complex deps (fastmcp, curl-cffi) not in nixpkgs, so use uv
  home.activation.installFli = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.uv}/bin/uv tool install flights 2>/dev/null \
      || $DRY_RUN_CMD ${pkgs.uv}/bin/uv tool upgrade flights 2>/dev/null \
      || true
  '';

  sonntag.mcp.fli.enable = true;

  sonntag.services.ollama.enable = true;
}
