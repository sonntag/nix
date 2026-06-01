{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.den.flakeModule
    inputs.den.flakeOutputs.homeConfigurations
  ];

  systems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
  den.schema.user.classes = lib.mkDefault ["homeManager"];
}
