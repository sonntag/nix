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
      awscli2
      # azure-cli
      babashka
      cljstyle
      clojure
      clojure-lsp
      jet
      # kubectx
      # kubelogin
      nodejs
    ];

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
