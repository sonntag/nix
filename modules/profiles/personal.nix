{den, ...}: {
  # These are the aspects that should only be on my personal hosts
  den.aspects.personal = {
    includes = with den.aspects; [
      anonymous
      dropbox
      nix-homebrew
      printing-3d
      recording
    ];

    darwin.homebrew.casks = [
      "chatgpt"
      "little-snitch"
      "logseq"
      "obsidian"
      "readdle-spark"
      "thebrowsercompany-dia"
      "whatsapp"
      "zen"
      "zoom"
    ];

    darwin.homebrew.masApps = {
      DaisyDisk = 411643860;
      Screens = 1663047912;
    };
  };
}
