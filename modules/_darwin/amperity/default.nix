{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.amperity;
in {
  options.amperity.enable = mkEnableOption "amperity";
  config = mkIf cfg.enable {
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

    # Configure homebrew.
    # Goal of this default configuration is to have nix install the apps that are
    # listed, but to otherwise leave the homebrew installation untouched so that
    # it behaves as if it is not managed by nix.
    homebrew = {
      enable = true;
      caskArgs.no_quarantine = lib.mkDefault true;

      taps = [
        "conductorone/homebrew-cone"
        "hashicorp/homebrew-tap"
      ];

      brews = [
        "azure-cli"
        "conductorone/cone/cone"
        "docker-compose"
        "hashicorp/tap/vault"
        # TODO: get this from nixpkgs instead
        "leiningen"
        "tfenv"
        "uv"
      ];

      casks = [
        "chromedriver"
        "docker-desktop"
        "temurin@17"
        "google-chrome"
        "slack"
        "zoom"
      ];
    };
  };
}
