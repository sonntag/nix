{lib, inputs, ...}: let
  pkgsOverlay = final: _:
    builtins.listToAttrs
    (map (name: {
        name = lib.removeSuffix ".nix" name;
        value = final.callPackage (../../pkgs + "/${name}") {};
      })
      (builtins.attrNames (lib.filterAttrs
        (name: type: type == "regular" && lib.hasSuffix ".nix" name)
        (builtins.readDir ../../pkgs))));
  pkgsFor = system: import inputs.nixpkgs {
    inherit system;
    overlays = [pkgsOverlay];
  };
  mkHome = system: {
    pkgs = pkgsFor system;
    instantiate = {pkgs, modules}: inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs modules;
      extraSpecialArgs = {inherit inputs;};
    };
  };
in {
  den.homes.aarch64-darwin.justin = mkHome "aarch64-darwin";
  den.homes.x86_64-linux.justin = mkHome "x86_64-linux";
  den.homes.aarch64-linux.justin = mkHome "aarch64-linux";
}
