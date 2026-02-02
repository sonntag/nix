{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    memory.source = ./claude-memory.md;
    settings.includeCoAuthoredBy = false;
    skillsDir = ./skills;
  };
}
