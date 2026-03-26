{
  imports = [
    ./atlassian.nix
    ./playwright.nix
    ./slack.nix
  ];
  programs.mcp.enable = true;
}
