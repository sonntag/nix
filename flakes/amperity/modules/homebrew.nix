{lib, ...}: {
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
      "conductorone/cone/cone"
      "docker-compose"
      "hashicorp/tap/vault"
      # TODO: get this from nixpkgs instead
      "leiningen"
      "tfenv"
    ];

    casks = [
      "chromedriver"
      "docker"
      "google-chrome"
      "slack"
      "snowflake-snowsql"
      "zoom"
    ];
  };
}
