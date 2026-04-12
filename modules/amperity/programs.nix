{
  den.aspects.amperity.darwin = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # azure-cli
      babashka
      bbin
      cljstyle
      clojure
      clojure-lsp
      jet
      # kubectx
      # kubelogin
    ];

    # Make claude-code use bedrock globally
    # environment.variables = {
    #   AWS_PROFILE = "sre";
    #   AWS_REGION = "us-west-2";
    #   ANTHROPIC_MODEL = "us.anthropic.claude-opus-4-5-20251101-v1:0";
    #   CLAUDE_CODE_USE_BEDROCK = "1";
    # };
  };
}
