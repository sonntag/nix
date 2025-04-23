{
  plugins.cursorline = {
    enable = true;
    settings = {
      # TODO: get rid of cursorline and find something to replace it with
      cursorline = {
        enable = false;
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
