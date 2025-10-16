{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/home
  ];
  sonntag.secrets.enable = true;
  sonntag.programs.nvim.enable = true;
  # sonntag.programs.nixvim.enable = true;
  darwin.wallpaper.image.path = ../backgrounds/rose-pine/leafy.png;

  darwin.dock = {
    enable = true;
    entries = [
      {path = "/System/Applications/Messages.app";}
      {path = "/Applications/Arc.app";}
      {path = "/Applications/Spark Desktop.app";}
      {path = "/Applications/Things3.app";}
      {path = "/Applications/Obsidian.app";}
      {path = "/System/Applications/Calendar.app";}
      {path = "/Applications/Ghostty.app";}
      {path = "/Applications/ChatGPT.app";}
      # {path = "${pkgs.spotify}/Applications/Spotify.app";}
      {
        path = "${config.home.homeDirectory}/Desktop";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
      {
        path = "${config.home.homeDirectory}/Downloads";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
    ];
  };

  home.packages = with pkgs; [
    clojure
  ];
}
