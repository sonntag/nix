{pkgs, ...}: {
  imports = [
    ./auto-save.nix
    ./conform.nix
    ./cursorline.nix
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
    tmux-navigator.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    # tabout-nvim
    (pkgs.vimUtils.buildVimPlugin {
      name = "mini.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "echasnovski";
        repo = "mini.nvim";
        rev = "c665f30bb372c2ec8cfd61f7531098d3658b6634";
        hash = "sha256-WM2AiRJA0P2JiW/z6K5wUGKp2BSjSAtTuR/rB66Eg9M=";
      };
    })
  ];

  # extraConfigLua = ''
  #   require("tabout").setup({
  #     act_as_tab = false,
  #     ignore_beginning = true,
  #     tabkey = "",
  #     backwards_tabkey = ""
  #   })
  # '';
}
