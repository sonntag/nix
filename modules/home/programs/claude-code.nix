{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.sonntag.programs.claude-code;
in {
  options = {
    sonntag.programs.claude-code.enable = mkEnableOption "claude code";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
    ];

    home.sessionVariables = {
      AWS_PROFILE = "sre";
      AWS_REGION = "us-west-2";
      # ANTHROPIC_MODEL = "us.anthropic.claude-sonnet-4-5-20250929-v1:0";
      ANTHROPIC_MODEL = "us.anthropic.claude-opus-4-5-20251101-v1:0";
      CLAUDE_CODE_USE_BEDROCK = "1";
    };
  };
}
