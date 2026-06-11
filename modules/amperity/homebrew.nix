{
  # Configure homebrew.
  # Goal of this default configuration is to have nix install the apps that are
  # listed, but to otherwise leave the homebrew installation untouched so that
  # it behaves as if it is not managed by nix.
  den.aspects.amperity.darwin = {
    homebrew = {
      enable = true;

      taps = [
        "conductorone/cone"
        "hashicorp/tap"
        "amperity/dev"
      ];

      brews = [
        "azure-cli"
        "amperity/dev/devbox"
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
        "temurin@17"
        "google-chrome"
        "slack"
        "zoom"
      ];
    };
  };
}
