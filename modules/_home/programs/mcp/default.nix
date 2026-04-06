{
  imports = [
    ./atlassian.nix
    ./codebase-memory.nix
    ./playwright.nix
    ./slack.nix
  ];
  programs.mcp.enable = true;
}
