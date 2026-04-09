{
  den.aspects.justin.homeManager = {
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      cfg = config.sonntag.mcp.fli;
    in {
      options.sonntag.mcp.fli.enable = mkEnableOption "fli flights MCP";
      config = mkIf cfg.enable {
        programs.mcp.servers.fli = {
          command = "${pkgs.uv}/bin/uvx";
          args = ["--from" "flights" "fli-mcp"];
        };
      };
    };
}
