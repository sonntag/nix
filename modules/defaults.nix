{lib, ...}: let
  pkgsOverlay = final: _:
    builtins.listToAttrs
    (map (name: {
        name = lib.removeSuffix ".nix" name;
        value = final.callPackage (../pkgs + "/${name}") {};
      })
      (builtins.attrNames (lib.filterAttrs
        (name: type: type == "regular" && lib.hasSuffix ".nix" name)
        (builtins.readDir ../pkgs))));
in {
  den.default.darwin = {inputs, ...}: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.determinate.darwinModules.default
      inputs.comin.darwinModules.comin
      inputs.sops-nix.darwinModules.sops
    ];
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [pkgsOverlay];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };

  den.default.homeManager = {
    home.stateVersion = "24.05";
    fonts.fontconfig.enable = true;
  };
}
