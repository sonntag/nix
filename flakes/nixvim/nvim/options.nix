{
  opts = {
    autoindent = true;
    backspace = "indent,eol,start";
    # cursorline = true; # puts a line under the cursorline
    expandtab = true; # no tabs!
    ignorecase = true; # ignore case for autocomplete in command mode
    mouse = "a";
    number = false;
    # relativenumber = true;
    scrolloff = 4; # makes sure the cursor is buffered by 4 lines when scrolling
    shiftwidth = 4; # set tab width to 4
    showmode = false; # don't show mode
    signcolumn = "yes"; # don't know what sign column is but I'm always showing it
    smartcase = true; # ignore "ignorecase" if autocomplete input contains capitals
    smartindent = true; # trying this, says it works well for c-like programs so may not work for clojure
    splitbelow = true;
    splitright = true; # splits screen down and to the right
    swapfile = false; # don't use swapfiles
    tabstop = 4;
    termguicolors = true;
    undofile = true;
    undolevels = 100;
    virtualedit = "block"; # highlight in blocks for visual block mode (ctrl-v)
    wrap = false;
  };

  clipboard = {
    # syncs system clipboard with Neovim's
    register = "unnamedplus";
  };
}
