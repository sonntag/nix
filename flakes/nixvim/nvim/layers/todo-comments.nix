{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.todo-comments;
in {
  options.sonntag.layers.todo-comments.enable = mkEnableOption "todo-comments" // {default = true;};
  # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
  config.plugins.todo-comments = mkIf cfg.enable {
    enable = true;
    settings.signs = true;
  };
}
