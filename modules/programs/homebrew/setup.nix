{
  den.default.darwin = {inputs, ...}: let
    inherit (inputs) nix-homebrew;
  in {
    imports = [nix-homebrew.darwinModules.nix-homebrew];

    homebrew = {
      enable = true;
      onActivation.cleanup = "zap";
    };

    nix-homebrew = {
      enable = true;
      autoMigrate = true;
      enableRosetta = false;
    };
  };
}
