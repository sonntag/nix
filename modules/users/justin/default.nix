{den, ...}: {
  den.aspects.justin = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
    ];
    darwin = {pkgs, ...}: {
      users.knownUsers = ["justin"];
      users.users.justin = {
        uid = 501;
        shell = pkgs.fish;
      };
    };
    homeManager = {
      imports = [../../_home];
    };
  };
}
