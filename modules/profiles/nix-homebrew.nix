{
  den.aspects.nix-homebrew.darwin = {inputs, ...}: {
    imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];

    nix-homebrew = {
      enable = true;
      autoMigrate = true;
      enableRosetta = false;
    };
  };
}
