{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.treesitter;
in {
  options.sonntag.layers.treesitter.enable = mkEnableOption "treesitter" // {default = true;};
  config.plugins = mkIf cfg.enable {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };

      # Without this it will try to load all grammars in nix, which causes
      # Oil to be visibly slow (and maybe other things). Instead, load
      # no grammars by default and we can add them in the language modules
      grammarPackages = [];
    };

    treesitter-context.enable = true;
  };
}
