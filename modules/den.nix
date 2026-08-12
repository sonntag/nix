{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.den.flakeModule
    inputs.den.flakeOutputs.homeConfigurations
    # Export only explicitly namespaced, reusable aspects. Existing personal
    # configuration remains under den.aspects.
    (inputs.den.namespace "sonntag" true)
  ];

  systems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
  # Host aspects are projected into every class listed here. Including
  # `nixible` lets host policies participate when resolving a user's playbooks.
  den.schema.user.classes = lib.mkDefault ["homeManager" "nixible"];
}
