{
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };
  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }

    {
      mode = "n";
      key = "<left>";
      action = "<cmd>echo 'Use h to move!!'<CR>";
    }
    {
      mode = "n";
      key = "<right>";
      action = "<cmd>echo 'Use l to move!!'<CR>";
    }
    {
      mode = "n";
      key = "<up>";
      action = "<cmd>echo 'Use k to move!!'<CR>";
    }
    {
      mode = "n";
      key = "<down>";
      action = "<cmd>echo 'Use j to move!!'<CR>";
    }
  ];
}
