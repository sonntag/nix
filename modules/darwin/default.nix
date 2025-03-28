{
  inputs,
  overlays ? [],
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) nix-darwin home-manager;

  defaultModules = [
    {
      imports = [
        ./programs
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
  ];
in
  nix-darwin.lib.darwinSystem {
    modules = defaultModules ++ modules;
    specialArgs = {inherit inputs;} // args;
  }
