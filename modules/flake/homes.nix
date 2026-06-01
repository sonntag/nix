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
  linuxPkgs = system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [pkgsOverlay];
  };
  mkHome = system: {
    pkgs = linuxPkgs system;
    instantiate = {pkgs, modules}: inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs modules;
      extraSpecialArgs = {inherit inputs;};
    };
  };
in {
  den.homes.x86_64-linux.justin = mkHome "x86_64-linux";
  den.homes.aarch64-linux.justin = mkHome "aarch64-linux";
}
