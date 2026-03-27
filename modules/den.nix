{
  inputs,
  den,
  lib,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.schema.user.classes = lib.mkDefault ["homeManager"];

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
    homeManager = {pkgs, ...}: {
      imports = [./_home];
      sonntag.programs.nvim.enable = true;
    };
  };
}
