{
  imports = [
    ./atlassian.nix
    ./fli.nix
    ./playwright.nix
    ./slack.nix
  ];
  programs.mcp.enable = true;
}
