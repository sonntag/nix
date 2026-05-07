{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.den.flakeModule];

  systems = ["aarch64-darwin"];
  den.schema.user.classes = lib.mkDefault ["homeManager"];
}
