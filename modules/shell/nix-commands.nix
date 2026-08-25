{...}: {
  den.aspects.justin.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.nixctl];
  };
}
