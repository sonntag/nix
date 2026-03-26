{
  # Installing goose through home-manager requires compiling everything,
  # so installing with homebrew instead
  homebrew = {
    brews = ["block-goose-cli"];
    casks = ["block-goose"];
  };
}
