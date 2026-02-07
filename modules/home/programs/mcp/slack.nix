{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.mcp.slack;
in {
  options.sonntag.mcp.slack.enable = mkEnableOption "slack mcp";
  config = mkIf cfg.enable {
    programs.mcp.servers.slack = {
      command = "${pkgs.slack-mcp-server}/bin/slack-mcp-server";
      args = ["--transport" "stdio"];
    };
  };
}
