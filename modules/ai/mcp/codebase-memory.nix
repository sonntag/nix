{
  den.aspects.justin.homeManager = {pkgs, ...}: let
    pkg = pkgs.codebase-memory-mcp;
    skill = name: builtins.readFile "${pkg}/share/claude-code-skills/${name}/SKILL.md";
  in {
    programs.mcp.servers.codebase-memory-mcp = {
      command = "${pkg}/bin/codebase-memory-mcp";
    };

    programs.claude-code.skills = {
      codebase-memory-exploring = skill "codebase-memory-exploring";
      codebase-memory-quality = skill "codebase-memory-quality";
      codebase-memory-reference = skill "codebase-memory-reference";
      codebase-memory-tracing = skill "codebase-memory-tracing";
    };
  };
}
