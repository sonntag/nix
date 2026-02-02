{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.mcp.slack;
in {
  options.sonntag.mcp.slack.enable = mkEnableOption "slack mcp";
  config = mkIf cfg.enable {
    programs.mcp.servers.slack = {
      type = "http";
      url = "https://mcp.slack.com/mcp";
    };
  };
}
