{
  imports = [
    ./keymaps.nix
    ./options.nix

    ./languages
    ./layers
    ./plugins
  ];

  sonntag.layers.performance.enable = true;

  sonntag.nvim.languages.clojure.enable = true;
  sonntag.nvim.languages.terraform.enable = true;

  colorschemes.rose-pine.enable = true;

  globals = {
    autoformat = true;

    mapleader = " ";
    maplocalleader = ",";
  };
}
