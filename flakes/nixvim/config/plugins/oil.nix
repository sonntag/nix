{
  plugins.oil.enable = true;
  keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<CMD>Oil<Cr>";
      options.desc = "Open parent directory";
    }
  ];
}
