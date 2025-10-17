{pkgs, ...}: {
  nix = {
    package = pkgs.lix;
    settings = {
      substituters = [
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
