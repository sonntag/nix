{
  den.default.darwin = {inputs, ...}: {
    imports = [
      ./_darwin/system
      inputs.home-manager.darwinModules.home-manager
      inputs.determinate.darwinModules.default
      inputs.comin.darwinModules.comin
      inputs.sops-nix.darwinModules.sops
    ];
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.overlays = [inputs.nix-custom-pkgs.overlays.default];
    nixpkgs.config.allowUnfree = true;
  };

  den.default.homeManager = {
    home.stateVersion = "24.05";
    fonts.fontconfig.enable = true;
  };
}
