{den, ...}: {
  den.aspects.justin = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      den.aspects.claude-code
      ({host ? null, ...}: {
        includes =
          if host == null
          then []
          else
            {
              greed = [den.aspects.amperity den.aspects.work];
              wrath = [den.aspects.personal];
            }
            .${
              host.name
            }
            or [
            ];
      })
    ];
    darwin = {pkgs, ...}: {
      users.knownUsers = ["justin"];
      users.users.justin = {
        uid = 501;
        shell = pkgs.fish;
      };
    };

    homeManager = {
      home.sessionPath = ["$HOME/.local/bin"];
    };
  };
}
