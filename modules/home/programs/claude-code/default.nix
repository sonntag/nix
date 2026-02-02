{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    settings.includeCoAuthoredBy = false;
    skillsDir = ./skills;
  };
}
