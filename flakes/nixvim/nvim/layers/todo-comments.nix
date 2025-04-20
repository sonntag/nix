{
  config,
  lib,
  util,
  ...
}:
with lib; let
  inherit (util) keymapLua;
  cfg = config.sonntag.layers.todo-comments;
in {
  options.sonntag.layers.todo-comments.enable = mkEnableOption "todo-comments" // {default = true;};
  # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
  config = {
    plugins.todo-comments = mkIf cfg.enable {
      enable = true;
      settings.signs = true;
    };

    keymaps = [
      (keymapLua "<leader>st" "Snacks.picker.todo_comments()" "Todo")
      (keymapLua "<leader>sT" "Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } })" "Todo/Fix/Fixme")
    ];
  };

  # TODO: how do I get a list of the todo comments?
}
