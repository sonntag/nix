{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "conductorone/cone"
      "nikitabobko/tap" # contains aerospace
    ];
    brews = [
      "azure-cli"
      "conductorone/cone/cone"
      "kanata"
      "tfenv"
    ];
    casks = [
      "1password"
      "1password-cli"
      "ableton-live-suite"
      "aerospace"
      "anki"
      "ankiapp"
      "arc"
      "bambu-studio"
      "blackhole-2ch"
      "chatgpt"
      "cljstyle"
      "desktoppr"
      "docker"
      "dropbox"
      "ghostty"
      "gifox"
      "gimp"
      "homerow"
      "iterm2"
      "nordvpn"
      "obsidian"
      "openscad"
      "raycast"
      "readdle-spark"
      "rekordbox"
      "slack"
      "snowflake-snowsql"
      "spotify"
      "sublime-text"
      "tableplus"
      "todoist"
      "tor-browser"
      "xnapper"
      "zen-browser"
      "zoom"
    ];
    masApps = {
      PCalc = 403504866;
      Things = 904280696;
      Yoink = 457622435;
    };
  };
}
