{inputs, ...}: {
  # Configure homebrew.
  # Goal of this default configuration is to have nix install the apps that are
  # listed, but to otherwise leave the homebrew installation untouched so that
  # it behaves as if it is not managed by nix.
  den.aspects.amperity.darwin = {
    nix-homebrew.taps = with inputs; {
      "conductorone/homebrew-cone" = homebrew-cone;
      "hashicorp/homebrew-tap" = homebrew-hashicorp;
      "amperity/homebrew-dev" = homebrew-amperity-dev;
    };

    homebrew = {
      enable = true;

      taps = [
        "conductorone/homebrew-cone"
        "hashicorp/homebrew-tap"
        "amperity/homebrew-dev"
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
