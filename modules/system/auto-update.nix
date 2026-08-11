{
  den.aspects.auto-update.darwin = {config, ...}: {
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
          url = "${config.users.users.justin.home}/.local/share/sonntag-nix";
          poller.period = 2;
        }
      ];
    };
  };
}
