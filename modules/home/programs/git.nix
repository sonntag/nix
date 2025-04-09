{lib, ...}: {
  programs.git = {
    enable = true;
    userName = "Justin Sonntag";
    userEmail = lib.mkDefault "justin.sonntag@gmail.com";
    iniContent = {
      core = {
        untrackedCache = true;
        fsmonitor = true;
      };
      init = {defaultBranch = "main";};
      pull = {rebase = false;};
      push = {autoSetupRemote = true;};
      rebase = {updateRefs = true;};
    };
    ignores = [
      "*.ignore.*"
      ".clj-kondo/babashka"
      ".clj-kondo/rewrite-clj"
    ];
    difftastic = {
      enable = true;
      enableAsDifftool = true;
      background = "dark";
    };
  };
}
