{
  plugins.cursorline = {
    enable = true;
    settings = {
      cursorline = {
        enable = true;
        number = false;
        timeout = 1000;
      };
      cursorword = {
        enable = true;
        hl = {
          underline = true;
        };
        min_length = 3;
      };
    };
  };
}
