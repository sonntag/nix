{util, ...}: let
  inherit (util) nmap;
in {
  imports = [
    ./auto-save.nix
    ./conform.nix
    ./mini-keymap.nix
    ./oil.nix
    ./which-key.nix
  ];

  plugins = {
    lualine.enable = true;
    lz-n.enable = true;
    mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = {};
    };
    sleuth.enable = true;
    snacks.enable = true;
    # TODO: this stopped working because tmux isn't able to detect that the pane is running nvim
    # Fix this and re-enable
    # tmux-navigator.enable = true;
  };

  # TODO: remove these keymaps when tmux-navigator is fixed
  keymaps = [
    (nmap "<C-h>" "<C-w>h")
    (nmap "<C-j>" "<C-w>j")
    (nmap "<C-k>" "<C-w>k")
    (nmap "<C-l>" "<C-w>l")
  ];

  # extraPlugins = with pkgs.vimPlugins; [
  #   tabout-nvim
  # ];

  # extraConfigLua = ''
  #   require("tabout").setup({
  #     act_as_tab = false,
  #     ignore_beginning = true,
  #     tabkey = "",
  #     backwards_tabkey = ""
  #   })
  # '';
}
