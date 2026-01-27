{pkgs, ...}: {
  sonntag.system.auto-update.enable = true;
  sonntag.darwin.personal-casks.enable = false;
  amperity.enable = true;

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/Messages.app"
      "/Applications/Arc.app"
      "/Applications/Spark Desktop.app"
      "/Applications/Things3.app"
      "/Applications/Obsidian.app"
      "/Applications/Slack.app"
      "/System/Applications/Calendar.app"
      "/Applications/Ghostty.app"
      "/Applications/zoom.us.app"
      "/Applications/Sublime Text.app"
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

  environment.systemPackages = with pkgs; [
    bun
    mkcert
    wget
    yq-go
  ];

  imports = [
    ./users.nix
    ./casks.nix
  ];
}
