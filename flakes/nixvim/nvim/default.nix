{
  imports = [
    ./profiles/coder

    ./keymaps.nix
    ./options.nix

    ./languages
    ./layers
    ./plugins
  ];

  colorschemes.rose-pine.enable = true;

  globals = {
    autoformat = true;

    mapleader = " ";
    maplocalleader = ",";
  };
}
