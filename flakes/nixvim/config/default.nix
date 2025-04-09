{
  # Import all your configuration modules here
  imports = [./bufferline.nix];

  colorschemes.rose-pine.enable = true;

  plugins = {
    lualine.enable = true;
  };
}
