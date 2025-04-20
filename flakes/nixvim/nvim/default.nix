{
  imports = [
    ./keymaps.nix
    ./options.nix

    ./languages
    ./layers
    ./plugins
  ];

  colorschemes.rose-pine.enable = true;
  sonntag.layers.performance.enable = false;

  globals = {
    autoformat = true;

    mapleader = " ";
    maplocalleader = ",";
  };
}
