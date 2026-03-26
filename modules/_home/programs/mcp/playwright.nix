{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.mcp.playwright;
in {
  options.sonntag.mcp.playwright.enable = mkEnableOption "playwright mcp";
  config = mkIf cfg.enable {
    programs.mcp.servers.playwright = {
      command = "${pkgs.playwright-mcp}/bin/mcp-server-playwright";
    };
  };
}
