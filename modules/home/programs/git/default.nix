{...}: {
  programs.git = {
    enable = true;
    userName = "justin";
    userEmail = "justin.sonntag@gmail.com";
    iniContent = {"pull" = {"rebase" = true;};};
  };
}
