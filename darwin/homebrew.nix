{
  homebrew = {
    enable = true;
    # nix-homebrew is handling homebrew updates
    global.autoUpdate = false;
    onActivation = {
      # "zap" removes manually installed brews and casks
      cleanup = "zap";
      # nix-homebrew is handling homebrew updates
      autoUpdate = false;
      upgrade = true;
    };
    caskArgs = {no_quarantine = true;};
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
