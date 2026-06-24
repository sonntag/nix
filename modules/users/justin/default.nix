{den, ...}: {
  den.aspects.justin = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      den.aspects.nixible
      ({host ? null, ...}: {
        includes =
          if host == null
          then []
          else
            {
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
      sonntag.wallpaper.image.path = ../../../backgrounds/rancho-cucamonga-tree.png;
    };
  };
}
