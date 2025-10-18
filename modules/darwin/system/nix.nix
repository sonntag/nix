{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.nix;
  isDeterminate = cfg.provider == "determinate";
  nix-packages = {
    "determinate" = inputs.determinate.inputs.nix.packages.aarch64-darwin.default;
    "nix" = pkgs.nix;
    # TODO: This should be set in an overlay: https://lix.systems/add-to-config/#flake-based-configurations
    "lix" = pkgs.lixPackageSets.stable.lix;
  };
in {
  options.sonntag.nix = {
    provider = mkOption {
      type = lib.types.enum ["determinate" "nix" "lix"];
      default = "determinate";
      description = "The provider type for the nix system";
    };
    trusted-users = mkOption {
      type = types.listOf types.str;
      default = ["root" "justin"];
      description = "Nix trusted users";
    };
  };
  config = {
    nix = {
      enable = !isDeterminate;
      package = nix-packages.${cfg.provider};
      settings = mkIf (!isDeterminate) {
        inherit (cfg) trusted-users;
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

    determinate-nix.customSettings = mkIf isDeterminate {
      inherit (cfg) trusted-users;
      # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
      eval-cores = 0;
      extra-experimental-features = [
        "build-time-fetch-tree" # Enables build-time flake inputs
        "parallel-eval" # Enables parallel evaluation
      ];
    };
  };
}
