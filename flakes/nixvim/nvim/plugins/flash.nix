{
  plugins.flash = {
    enable = true;
    settings.keys = [
      {
        __unkeyed-1 = "s";
        __unkeyed-3 = ''function() require("flash").jump() end'';
        mode = ["n" "x" "o"];
        desc = "Flash";
      }
    ];
  };
}
