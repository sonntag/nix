{lib, ...}: {
  programs.jjui.enable = true;
  programs.jujutsu = with lib; {
    enable = true;
    settings = {
      user = {
        name = "Justin Sonntag";
        email = mkDefault "justin.sonntag@gmail.com";
      };
      ui.diff-formatter = ["difft" "--color=always" "$left" "$right"];
    };
  };
}
