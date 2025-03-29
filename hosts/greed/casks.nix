{inputs, ...}: {
  nix-homebrew = {
    taps = with inputs; {
      "conductorone/homebrew-cone" = homebrew-cone;
      "hashicorp/homebrew-tap" = homebrew-hashicorp;
      "borkdude/homebrew-brew" = homebrew-borkdude;
    };
  };

  homebrew.brews = [
    "borkdude/brew/jet"
    "conductorone/cone/cone"
    "docker-compose"
    "hashicorp/tap/vault"
    "tfenv"
  ];

  homebrew.casks = [
    "chromedriver"
    "docker"
    "google-chrome"
    "slack"
    "snowflake-snowsql"
    "tableplus"
    "zoom"
  ];
}
