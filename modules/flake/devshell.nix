{...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = [pkgs.sops pkgs.age];
    };
  };
}
