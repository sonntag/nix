{
  den.default.darwin = {
    config,
    inputs,
    lib,
    ...
  }:
    with lib; let
      cfg = config.sonntag.nix;
    in {
      options.sonntag.nix = {
        trusted-users = mkOption {
          type = types.listOf types.str;
          default = ["root" "justin"];
          description = "Nix trusted users";
        };
      };
      config = {
        nix = {
          enable = false;
          package = inputs.determinate.inputs.nix.packages.aarch64-darwin.default;
        };

        determinateNix.customSettings = {
          inherit (cfg) trusted-users;
          # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
          eval-cores = 0;
          extra-experimental-features = [
            "build-time-fetch-tree" # Enables build-time flake inputs
            "parallel-eval" # Enables parallel evaluation
          ];
          extra-substituters = [
            "https://cache.nixos.org"
            "https://sonntag.cachix.org"
            "https://nvim-treesitter-main.cachix.org"
            "https://helix.cachix.org"
          ];
          extra-trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "sonntag.cachix.org-1:4rHXwjmC/EpRwVkCyH0xLQaoeZT9C0oq8TINGSap1Wk="
            "nvim-treesitter-main.cachix.org-1:cbwE6blfW5+BkXXyeAXoVSu1gliqPLHo2m98E4hWfZQ="
            "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
          ];
        };
      };
    };
}
