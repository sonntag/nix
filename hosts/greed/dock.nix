let
  user = "justin";
in {
  local = {
    dock.enable = true;
    dock.entries = [
      {path = "/System/Applications/Messages.app";}
      {path = "/Applications/Arc.app";}
      {path = "/Applications/Spark Desktop.app";}
      {path = "/Applications/Things3.app";}
      {path = "/Applications/Obsidian.app";}
      {path = "/Applications/Slack.app";}
      {path = "/System/Applications/Calendar.app";}
      {path = "/Applications/Ghostty.app";}
      {path = "/Applications/zoom.us.app";}
      {path = "/Applications/Sublime Text.app";}
      {
        path = "/Users/${user}/Desktop";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
      {
        path = "/Users/${user}/Downloads";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
    ];
  };
}
