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
        ./system/dock.nix
        ./security/touch-id.nix
      ];
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;
      networking.hostName = hostName;
      nixpkgs = {
        inherit overlays hostPlatform;
        config.allowUnfree = true;
      };
      programs.fish.enable = true;
    }

    home-manager.darwinModules.home-manager
  ];
in
  nix-darwin.lib.darwinSystem {
    modules = defaultModules ++ modules;
    specialArgs = {inherit inputs;} // args;
  }
