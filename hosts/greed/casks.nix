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
    "chatwise"
    "chromedriver"
    "docker"
    "google-chrome"
    "mouseless"
    "slack"
    "snowflake-snowsql"
    "sublime-text"
    "tableplus"
    "zoom"
  ];
}
