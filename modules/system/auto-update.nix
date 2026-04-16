{
  den.aspects.auto-update.darwin = {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/sonntag/nix.git";
          branches.main.name = "main";
        }
        {
          name = "local";
          # TODO: Pull this from a common config
          url = "/Users/justin/Development/sonntag/nix";
          poller.period = 2;
        }
      ];
    };
  };
}
