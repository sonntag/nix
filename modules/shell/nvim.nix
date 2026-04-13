{
  den.aspects.justin.homeManager = {inputs, ...}: {
    home.packages = [
      # TODO: this should depend on ${system}
      inputs.nvim.packages.aarch64-darwin.default
    ];
    home.sessionVariables.EDITOR = "nvim";
  };
}
