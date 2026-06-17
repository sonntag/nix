{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    programs.mcp.servers.playwright = {
      command = "${pkgs.playwright-mcp}/bin/mcp-server-playwright";
    };
  };
}
