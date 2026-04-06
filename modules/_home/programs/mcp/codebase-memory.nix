{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.mcp.codebase-memory;
in {
  options.sonntag.mcp.codebase-memory.enable = mkEnableOption "codebase-memory mcp";
  config = mkIf cfg.enable {
    programs.mcp.servers.codebase-memory-mcp = {
      command = "${pkgs.codebase-memory-mcp}/bin/codebase-memory-mcp";
    };
  };
}
