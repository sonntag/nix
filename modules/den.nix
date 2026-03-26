{
  inputs,
  den,
  lib,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.schema.user.classes = lib.mkDefault ["homeManager"];

  den.hosts.aarch64-darwin.wrath.users.justin = {};
  den.hosts.aarch64-darwin.greed.users.justin = {};

  den.aspects.wrath = {
    includes = [den.provides.hostname];
    # nixos = {pkgs, ...}: {environment.systemPackages = [pkgs.hello];};
  };

  den.aspects.justin = {
    includes = [den.provides.define-user den.provides.primary-user];
    # homeManager = {pkgs, ...}: {packages = [pkgs.vim];};
  };
}
