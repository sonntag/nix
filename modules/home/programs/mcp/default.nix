{
  imports = [
    ./atlassian.nix
    ./slack.nix
  ];
  programs.mcp.enable = true;
}
