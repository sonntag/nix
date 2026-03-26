{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.mcp.atlassian;
in {
  options.sonntag.mcp.atlassian.enable = mkEnableOption "atlassian mcp";
  config = mkIf cfg.enable {
    programs.mcp.servers.atlassian = {
      type = "sse";
      url = "https://mcp.atlassian.com/v1/mcp";
    };
  };
}
