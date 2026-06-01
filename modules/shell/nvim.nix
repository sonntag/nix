{
  den.aspects.justin.homeManager = {
    inputs,
    pkgs,
    ...
  }: {
    home.packages = [
      inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.sessionVariables.EDITOR = "nvim";
  };
}
