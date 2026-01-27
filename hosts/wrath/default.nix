{
  sonntag.system.auto-update.enable = true;

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/Messages.app"
      "/Applications/Arc.app"
      "/Applications/Spark Desktop.app"
      "/Applications/Things3.app"
      "/Applications/Obsidian.app"
      "/System/Applications/Calendar.app"
      "/Applications/Ghostty.app"
      "/Applications/ChatGPT.app"
    ];
    persistent-others = [
      {
        folder = {
          path = "/Users/justin/Desktop";
          displayas = "stack";
          showas = "fan";
          arrangement = "date-added";
        };
      }
      {
        folder = {
          path = "/Users/justin/Downloads";
          displayas = "stack";
          showas = "fan";
          arrangement = "date-added";
        };
      }
    ];
  };

  imports = [
    ./casks.nix
    ./users.nix
  ];
}
