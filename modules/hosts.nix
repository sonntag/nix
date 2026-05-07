{inputs, ...}: let
  withInputs = args: inputs.darwin.lib.darwinSystem (args // {
    specialArgs = (args.specialArgs or {}) // {inherit inputs;};
  });
in {
  den.hosts.aarch64-darwin.wrath = {
    users.justin = {};
    instantiate = withInputs;
  };
  den.hosts.aarch64-darwin.greed = {
    users.justin = {};
    instantiate = withInputs;
  };
}
