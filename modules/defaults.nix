{
  den.default.darwin = {inputs, ...}: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.determinate.darwinModules.default
      inputs.comin.darwinModules.comin
      inputs.sops-nix.darwinModules.sops
    ];
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.overlays = [inputs.nix-custom-pkgs.overlays.default];
    nixpkgs.config.allowUnfree = true;

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
