{
  inputs,
  overlays ? [],
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) comin determinate nix-darwin home-manager sops-nix;

  defaultModules = [
    {
      imports = [
        ./amperity
        ./programs
        ./secrets.nix
        ./services
        ./system
      ];
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
      networking.hostName = hostName;
      nixpkgs = {
        inherit overlays hostPlatform;
        config.allowUnfree = true;
      };
    }
    home-manager.darwinModules.home-manager
    determinate.darwinModules.default
    comin.darwinModules.comin
    sops-nix.darwinModules.sops
  ];
in
  nix-darwin.lib.darwinSystem {
    modules = defaultModules ++ modules;
    specialArgs = {inherit inputs;} // args;
  }
