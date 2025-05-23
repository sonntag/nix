{inputs, ...}: {
  nix-homebrew = {
    taps = with inputs; {
      "conductorone/homebrew-cone" = homebrew-cone;
      "hashicorp/homebrew-tap" = homebrew-hashicorp;
    };
  };

  homebrew.brews = [
    "conductorone/cone/cone"
    "docker-compose"
    "hashicorp/tap/vault"
    # TODO: get this from nixpkgs instead
    "leiningen"
    "tfenv"
  ];

  homebrew.casks = [
    "chatbox"
    "chatwise"
    "chromedriver"
    "docker"
    "google-chrome"
    "slack"
    "snowflake-snowsql"
    "sublime-text"
    "tableplus"
    "zoom"
  ];
}
