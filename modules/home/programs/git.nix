{lib, ...}: {
  programs.git = with lib; {
    enable = true;
    settings.user = {
      name = "Justin Sonntag";
      email = mkDefault "justin.sonntag@gmail.com";
    };
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
      ".clj-kondo/http-kit"
    ];
  };
}
