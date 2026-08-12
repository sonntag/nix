{den, ...}: {
  den.aspects.justin = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects
      (den.batteries.user-shell "fish")
    ];

    darwin.users = {
      knownUsers = ["justin"];
      users.justin.uid = 501;
    };

    homeManager = {
      home.sessionPath = ["$HOME/.local/bin"];
      sonntag.wallpaper.image.path = ../../../backgrounds/rancho-cucamonga-tree.png;
    };
  };
}
