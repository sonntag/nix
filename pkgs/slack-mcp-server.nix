{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "slack-mcp-server";
  version = "1.1.28";

  src = fetchFromGitHub {
    owner = "korotovsky";
    repo = "slack-mcp-server";
    tag = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  subPackages = ["cmd/slack-mcp-server"];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Slack MCP server for Claude and other AI assistants";
    homepage = "https://github.com/korotovsky/slack-mcp-server";
    license = licenses.mit;
    mainProgram = "slack-mcp-server";
  };
}
