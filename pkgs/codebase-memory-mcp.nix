{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  version = "0.5.7";
  platform =
    {
      "aarch64-darwin" = "darwin-arm64";
      "x86_64-linux" = "linux-amd64";
      "aarch64-linux" = "linux-arm64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash =
    {
      "aarch64-darwin" = "sha256-sOZJodUmgL4teEherr/N0Qd6mu81EQE6L36OpTlkvK0=";
      "x86_64-linux" = "";
      "aarch64-linux" = "";
    }
    .${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "codebase-memory-mcp";
  inherit version;

  src = fetchurl {
    url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-${platform}.tar.gz";
    inherit hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [autoPatchelfHook];

  installPhase = ''
    install -Dm755 codebase-memory-mcp $out/bin/codebase-memory-mcp
  '';

  meta = with lib; {
    description = "MCP server that builds a knowledge graph of your codebase";
    homepage = "https://github.com/DeusData/codebase-memory-mcp";
    license = licenses.mit;
    mainProgram = "codebase-memory-mcp";
  };
}
