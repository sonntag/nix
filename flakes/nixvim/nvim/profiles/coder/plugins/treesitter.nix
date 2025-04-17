{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };

    # TODO: something

    # TODO: yes

    # Without this it will try to load all grammars in nix, which causes
    # Oil to be visibly slow (and maybe other things). Instead, load
    # no grammars by default and we can add them in the language modules
    grammarPackages = [];
  };
}
